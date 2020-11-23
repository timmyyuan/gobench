package gobench

import (
	"context"
	"fmt"
	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types/mount"
	"github.com/docker/docker/client"
	"github.com/docker/docker/pkg/stdcopy"
	"io/ioutil"
	"log"
	"os"
	"strings"
	"time"
)

func FindImage(name string) (types.ImageSummary, bool) {
	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		panic(err)
	}

	images, err := cli.ImageList(context.Background(), types.ImageListOptions{})
	if err != nil {
		panic(err)
	}

	for _, img := range images {
		if strings.HasPrefix(img.RepoTags[0], name) {
			return img, true
		}
	}

	return types.ImageSummary{}, false
}

func FindContainer(name string) (types.Container, bool) {
	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		panic(err)
	}

	cntrs, err := cli.ContainerList(context.Background(), types.ContainerListOptions{
		Quiet: true,
		All:   true,
	})

	if err != nil {
		panic(err)
	}

	for _, cntr := range cntrs {
		if cntr.Names[0] == "/"+name {
			return cntr, true
		}
	}

	return types.Container{}, false
}

func RemoveImage(id string) bool {
	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		panic(err)
	}

	items, err := cli.ImageRemove(context.Background(), id, types.ImageRemoveOptions{
		Force:         true,
		PruneChildren: true,
	})

	if err != nil {
		panic(err)
	}

	return len(items) > 0
}

func RemoveContainer(name string) bool {
	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		panic(err)
	}

	cntr, ok := FindContainer(name)

	if !ok {
		return false
	}

	ctx := context.Background()

	if err := cli.ContainerRemove(ctx, cntr.ID, types.ContainerRemoveOptions{}); err != nil {
		panic(err)
	}

	statusCh, errCh := cli.ContainerWait(ctx, cntr.ID, container.WaitConditionRemoved)

	select {
	case <-errCh:
		// errors only happen when the container already be removed. So it is ok here.
	case <-statusCh:
	}

	return true
}

type CntrContextConfig struct {
	Name      string
	ImageName string

	EntryPoint []string

	Privileged bool
	AutoRemove bool
	Client     *client.Client
}

type CntrContext struct {
	CntrContextConfig

	ID      string
	done    chan struct{}
	stopped chan struct{}
}

func NewCntrContext(config CntrContextConfig) *CntrContext {
	c := &CntrContext{
		CntrContextConfig: config,
		done:              make(chan struct{}),
		stopped:           make(chan struct{}),
	}

	if len(c.EntryPoint) == 0 {
		c.EntryPoint = append(c.EntryPoint, "sleep", "36h")
	}

	c.start()

	return c
}

func NewCntrExec(config CntrContextConfig, env []string) ([]byte, int) {
	c := &CntrContext{
		CntrContextConfig: config,
		done:              make(chan struct{}),
		stopped:           make(chan struct{}),
	}

	if len(c.EntryPoint) == 0 {
		panic(fmt.Errorf("Expect a entrypoint but found nothing for %s", config.Name))
	}

	return c.exec()
}

func (c *CntrContext) exec() ([]byte, int) {
	ctx := context.Background()
	stopTimeout := 3600 * 4 // 4 hours
	config := &container.Config{
		Image:        c.ImageName,
		Cmd:          c.EntryPoint,
		Tty:          false,
		AttachStdout: true,
		AttachStderr: true,
		StopTimeout:  &stopTimeout,
	}
	hostConfig := &container.HostConfig{
		AutoRemove: false,
		Privileged: c.Privileged,
		Mounts: []mount.Mount{
			{
				Type:   mount.TypeBind,
				Source: "/var/run/docker.sock",
				Target: "/var/run/docker.sock",
			},
			{
				Type:   mount.TypeBind,
				Source: "/usr/bin/docker",
				Target: "/usr/bin/docker",
			},
		},
	}

	resp, err := c.Client.ContainerCreate(ctx, config, hostConfig, nil, c.Name)
	if err != nil {
		panic(fmt.Errorf("Expect %v to be created but %v", c.Name, err))
	}
	c.ID = resp.ID

	if err := c.Client.ContainerStart(ctx, c.ID, types.ContainerStartOptions{}); err != nil {
		panic(err)
	}
	defer RemoveContainer(c.Name)

	statusCh, errCh := c.Client.ContainerWait(ctx, c.ID, container.WaitConditionNotRunning)
	var exitcode int
	select {
	case <-errCh:
	case <-statusCh:
	}

	logs, err := c.Client.ContainerLogs(ctx, c.ID, types.ContainerLogsOptions{ShowStdout: true, ShowStderr: true})
	if err != nil {
		panic(err)
	}

	var out []byte
	WithTempFile(c.Name+"_*_output", "", func(tmpfile string) {
		file, err := os.OpenFile(tmpfile, os.O_WRONLY, 0644)
		if err != nil {
			panic(err)
		}
		if _, err := stdcopy.StdCopy(file, file, logs); err != nil {
			panic(err)
		}

		if err := file.Close(); err != nil {
			panic(err)
		}

		out, _ = ioutil.ReadFile(tmpfile)
	})

	return out, exitcode
}

func (c *CntrContext) start() {
	ctx := context.Background()
	config := &container.Config{
		Image:        c.ImageName,
		Cmd:          c.EntryPoint,
		Tty:          false,
		AttachStderr: true,
		AttachStdout: true,
	}
	hostConfig := &container.HostConfig{
		AutoRemove: c.AutoRemove,
		Privileged: c.Privileged,
		Mounts: []mount.Mount{
			{
				Type:   mount.TypeBind,
				Source: "/var/run/docker.sock",
				Target: "/var/run/docker.sock",
			},
			{
				Type:   mount.TypeBind,
				Source: "/usr/bin/docker",
				Target: "/usr/bin/docker",
			},
		},
	}

	resp, err := c.Client.ContainerCreate(ctx, config, hostConfig, nil, c.Name)
	if err != nil {
		panic(fmt.Errorf("Expect %v to be created but %v", c.Name, err))
	}
	c.ID = resp.ID

	if err := c.Client.ContainerStart(ctx, c.ID, types.ContainerStartOptions{}); err != nil {
		panic(err)
	}
	// log.Printf("docker run %s %s\n", c.ImageName, strings.Join(c.EntryPoint, " "))

	go func() {
		defer func() {
			defer close(c.stopped)
			var timeout = time.Second
			if err := c.Client.ContainerStop(ctx, c.ID, &timeout); err != nil {
				panic(err)
			}
			var statusCh <-chan container.ContainerWaitOKBody
			var errCh <-chan error
			if c.AutoRemove {
				statusCh, errCh = c.Client.ContainerWait(ctx, c.ID, container.WaitConditionRemoved)
			} else {
				statusCh, errCh = c.Client.ContainerWait(ctx, c.ID, container.WaitConditionNotRunning)
			}
			select {
			case <-errCh:
				// errors only happen when the container already be removed. So it is ok here.
			case <-statusCh:
			}
		}()

		statusCh, errCh := c.Client.ContainerWait(ctx, c.ID, container.WaitConditionNotRunning)
		select {
		case err := <-errCh:
			if err != nil {
				log.Printf("Create container %v failed.\n", c.Client)
				panic(err)
			}
		case <-statusCh:
			// exec is not ok
			panic("ExecCmd is not finished in 10h")
		case <-c.done:
			return
		}
	}()

	for {
		cntr, ok := FindContainer(c.Name)
		if ok && cntr.State == "running" {
			break
		}
	}
}

func (c *CntrContext) Cancel() {
	close(c.done)
	select {
	case <-c.stopped:
	case <-time.After(time.Minute):
		panic(c.Name + " failed in shutdown")
	}
}

func (c *CntrContext) Exec(cmd []string, env []string) ([]byte, int) {
	ctx := context.Background()
	execid, err := c.Client.ContainerExecCreate(ctx, c.ID, types.ExecConfig{
		Tty:          false,
		AttachStderr: true,
		AttachStdout: true,
		Cmd:          cmd,
		Env:          append(os.Environ(), env...),
	})
	// log.Printf("docker exec %s %s\n", c.Name, strings.Join(cmd, " "))
	if err != nil {
		panic(err)
	}

	hijResp, err := c.Client.ContainerExecAttach(ctx, execid.ID, types.ExecStartCheck{})
	/// container may timed out
	if err != nil {
		return []byte(err.Error()), 1
	}

	if err := c.Client.ContainerExecStart(ctx, execid.ID, types.ExecStartCheck{}); err != nil {
		panic(err)
	}

	var out []byte
	WithTempFile(c.Name+"_*_output", "", func(tmpfile string) {
		file, err := os.OpenFile(tmpfile, os.O_WRONLY, 0644)
		if err != nil {
			panic(err)
		}
		if _, err := stdcopy.StdCopy(file, file, hijResp.Reader); err != nil {
			panic(err)
		}

		if err := file.Close(); err != nil {
			panic(err)
		}

		out, _ = ioutil.ReadFile(tmpfile)
	})

	inspect, err := c.Client.ContainerExecInspect(ctx, execid.ID)

	if err != nil {
		panic(err)
	}

	return out, inspect.ExitCode
}
