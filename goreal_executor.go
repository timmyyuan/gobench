package gobench

import (
	"context"
	"fmt"
	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
	"github.com/docker/docker/pkg/archive"
	"github.com/docker/docker/pkg/jsonmessage"
	"github.com/hashicorp/go-version"
	"io/ioutil"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
)

type GoRealExecuter struct {
	*BatchRunResult
	Config        *GoRealBugConfig
	ImageName     string
	ContainerName string
	ExecCmd       []string

	client     *client.Client
	cntrCtx    *CntrContext
	privileged bool
}

func isMoby(bugid string) bool {
	return strings.HasPrefix(bugid, "moby")
}

func newGoRealExecuter(config ExecBugConfig) *GoRealExecuter {
	bugid := config.Bug.ID

	bugconfig := NewGoRealBugConfig(config.Bug, config.BugConfigPath)

	imageName := bugid + ":bug"
	if config.Tag != "" {
		imageName = bugid + ":" + config.Tag
	}

	g := &GoRealExecuter{
		BatchRunResult: &BatchRunResult{
			ExecBugConfig: config,
		},
		Config:        bugconfig,
		ImageName:     imageName,
		ContainerName: bugid + "_cntr",
	}

	if isMoby(bugid) {
		g.privileged = true
	}

	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		panic(err)
	}

	g.client = cli

	if len(g.Config.TestFunc) != 0 && strings.HasPrefix(g.Config.TestFunc, "make") {
		g.ExecCmd = strings.Split(g.Config.TestFunc, " ")
		return g
	}

	execCmd := []string{
		"/go/gobench.test",
		"-test.v",
		"-test.count",
	}

	if g.needRunOneByOne() {
		execCmd = append(execCmd, "1")
	} else {
		execCmd = append(execCmd, strconv.Itoa(g.Count))
	}

	if g.Cpu != 0 {
		execCmd = append(execCmd, "-test.cpu", strconv.Itoa(g.Cpu))
	}

	v1, _ := version.NewVersion("1.10")
	v2, _ := version.NewVersion(bugconfig.GoVersion)
	if !v2.LessThan(v1) && !isMoby(g.Bug.ID) {
		execCmd = append(execCmd, "-test.failfast")
	}

	/// Some bugs may failed silently in docker exec
	execCmd = append(execCmd, "-test.timeout", g.Timeout.String())

	if len(g.Config.TestFunc) != 0 {
		execCmd = append(execCmd, "-test.run", g.Config.TestFunc)
	}

	g.ExecCmd = execCmd

	return g
}

func (g *GoRealExecuter) TestEntryAndFunc() (string, string) {
	// FIXME should return the specific test file instead of the directory
	return g.Config.WorkDir, g.Config.TestFunc
}

func (g *GoRealExecuter) Build() {
	buildCtx, err := archive.TarWithOptions(g.SourceDir, &archive.TarOptions{})

	if err != nil {
		panic(err)
	}

	imageName := g.ImageName
	if isMoby(g.Bug.ID) {
		// Build the first stage
		imageName = g.Bug.ID + ":tmp"
	}

	resp, err := g.client.ImageBuild(context.Background(), buildCtx, types.ImageBuildOptions{
		Tags:           []string{imageName},
		Dockerfile:     "bug.Dockerfile",
		SuppressOutput: true,
	})

	if err != nil {
		panic(err)
	}

	defer resp.Body.Close()

	jsonmessage.DisplayJSONMessagesStream(resp.Body, os.Stdout, os.Stdout.Fd(), true, nil)

	if isMoby(g.Bug.ID) {
		// We need a mounted docker in the second stage
		tmpCntr := NewCntrContext(CntrContextConfig{
			Name:       g.ContainerName + "_tmp",
			ImageName:  imageName,
			AutoRemove: true,
			Client:     g.client,
		})
		defer tmpCntr.Cancel()

		// Build
		if g.Bug.ID == "moby_27037" {
			tmpCntr.Exec(strings.Split(g.Config.TestFunc, " "), g.Config.TestEnvs)

			// Commit
			_, err := g.client.ContainerCommit(context.Background(), tmpCntr.Name, types.ContainerCommitOptions{
				Reference: g.ImageName,
			})

			if err != nil {
				panic(err)
			}

			// moby_27037_cntr_tmp will be auto-removed in the defered Cancel().
			return
		}

		tmpCntr.Exec(strings.Split(g.Config.PredStageCmd, " "), g.Config.TestEnvs)

		// Commit
		_, err := g.client.ContainerCommit(context.Background(), g.ContainerName, types.ContainerCommitOptions{
			Reference: g.ImageName,
		})
		if err != nil {
			panic(err)
		}

		// Remove the container because its image already commited. We will use the container name in the
		// next stage (i.e. Run()).
		if RemoveContainer(g.ContainerName) == false {
			panic(fmt.Sprintf("%s should exist and be removed in the first stage.", g.ContainerName))
		}
	}
}

func (g *GoRealExecuter) runWithRecreateCntr() *SingleRunResult {
	execFunc := func(cmd []string, envs []string) ([]byte, int) {
		return NewCntrExec(CntrContextConfig{
			Name:       g.ContainerName,
			ImageName:  g.ImageName,
			EntryPoint: cmd,
			Privileged: true,
			Client:     g.client,
		}, envs)
	}
	result := g.next()
	result.Command = fmt.Sprintf("docker run %s %s", g.ImageName, strings.Join(g.ExecCmd, " "))
	result.process(func() {
		result.Logs, result.ExitCode = execFunc(g.ExecCmd, g.Config.TestEnvs)
	})

	backup := filepath.Join(g.OutputDir, "last-repeat.log")
	if err := ioutil.WriteFile(backup, []byte(result.log()), 0644); err != nil {
		panic(err)
	}

	return result
}

func (g *GoRealExecuter) runParallel(jobs int) *SingleRunResult {
	var onceFail, oncePass sync.Once
	var finished, firstfail int32
	var tasks []func()
	count := g.Count
	if count > 1000 {
		// hard code 1000 because these tests run slowly
		count = 1000
	}
	result := g.next()

	for i := 0; i < count; i++ {
		index := i
		tasks = append(tasks, func() {
			if atomic.LoadInt32(&finished) != 0 {
				return
			}
			cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
			if err != nil {
				panic(err)
			}

			cntrCtx := NewCntrContext(CntrContextConfig{
				Name:       g.ContainerName + "_" + strconv.Itoa(index),
				ImageName:  g.ImageName,
				Privileged: false,
				AutoRemove: true,
				Client:     cli,
			})
			defer cntrCtx.Cancel()

			logs, exitcode := cntrCtx.Exec(g.ExecCmd, g.Config.TestEnvs)
			if exitcode == 0 {
				oncePass.Do(func() {
					result.process(func() {
						result.Logs, result.ExitCode = logs, exitcode
					})
				})
				atomic.AddInt32(&firstfail, 1)
				return
			}

			onceFail.Do(func() {
				atomic.StoreInt32(&finished, int32(index+1))
				result.process(func() {
					result.Logs, result.ExitCode = logs, exitcode
				})
			})
		})
	}

	BatchJobs(tasks, jobs)

	result.FailFirst = float64(firstfail + 1)
	result.Command = fmt.Sprintf("docker exec %s %s", g.ContainerName, strings.Join(g.ExecCmd, " "))
	if finished == 0 {
		result.Command = fmt.Sprintf("[%v times] %s", count, result.Command)
	} else {
		result.Command = fmt.Sprintf("[%v times] %s", finished, result.Command)
	}

	backup := filepath.Join(g.OutputDir, "last-repeat.log")
	if err := ioutil.WriteFile(backup, []byte(result.log()), 0644); err != nil {
		panic(err)
	}

	return result
}

func (g *GoRealExecuter) Run() *SingleRunResult {
	if g.needRunFewerTimes() {
		return g.runParallel(runtime.GOMAXPROCS(0))
	}

	/*
	if !g.needRunOneByOne() {
		return g.runWithRecreateCntr()
	}
	 */

	if g.cntrCtx == nil {
		g.cntrCtx = NewCntrContext(CntrContextConfig{
			Name:       g.ContainerName,
			ImageName:  g.ImageName,
			AutoRemove: true,
			Privileged: true,
			Client:     g.client,
		})
	}

	result := g.next()
	result.Command = fmt.Sprintf("docker exec %s %s", g.cntrCtx.Name, strings.Join(g.ExecCmd, " "))

	var passed float64
	var failed bool
	result.process(func() {
		if !g.needRunOneByOne() {
			result.Logs, result.ExitCode = g.cntrCtx.Exec(g.ExecCmd, g.Config.TestEnvs)
			return
		}

		var i int
		for i = 0; i < g.Count; i++ {
			result.Logs, result.ExitCode = g.cntrCtx.Exec(g.ExecCmd, g.Config.TestEnvs)
			if result.PositiveCheckFunc(result) || result.ExitCode != 0 {
				failed = true
				break
			} else {
				passed += 1
			}
		}

		if i > 0 {
			result.Command = fmt.Sprintf("[%v times] %s", i, result.Command)
		}
	})

	if failed {
		result.FailFirst = passed + 1
	}

	backup := filepath.Join(g.OutputDir, "last-repeat.log")
	if err := ioutil.WriteFile(backup, []byte(result.log()), 0644); err != nil {
		panic(err)
	}

	return result
}

func (g *GoRealExecuter) Done() {
	if g.cntrCtx != nil {
		g.cntrCtx.Cancel()
	}
	backup := filepath.Join(g.OutputDir, "full.log")
	if err := ioutil.WriteFile(backup, []byte(g.log()), 0644); err != nil {
		panic(err)
	}
}

func (g *GoRealExecuter) GetResult() *BatchRunResult {
	return g.BatchRunResult
}

func (g *GoRealExecuter) needRunOneByOne() bool {
	/// All of tests will fail the first few times (except 16851)
	/// Run them carefully so we can save out time.
	specials := []string{
		"etcd_4876",
		"moby_18412",
		"moby_22941",
		"moby_27037",
		"cockroach_17766",
		"cockroach_1462",
		"cockroach_1055",
		"kubernetes_16851",
	}

	for _, id := range specials {
		if g.Bug.ID == id {
			return true
		}
	}
	return false
}

func (g *GoRealExecuter) needRunFewerTimes() bool {
	/// These tests take too much time. Run them fewer times (i.e. 1000)
	specials := []string{"kubernetes_16851"}
	for _, id := range specials {
		if g.Bug.ID == id {
			return true
		}
	}
	return false
}