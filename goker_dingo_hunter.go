package gobench

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

type DingoHunterExecuter struct {
	*BatchRunResult

	FileMigo string

	Source string
	TestFn string

	cntrCtx *CntrContext
}

func newDingoHunterExecuter(config ExecBugConfig) *DingoHunterExecuter {
	g := &DingoHunterExecuter{
		BatchRunResult: &BatchRunResult{
			ExecBugConfig: config,
		},
	}

	project, id := SplitBugID(g.Bug.ID)
	testfile := filepath.Join(g.SourceDir, fmt.Sprintf("%s%s_test.go", project, id))
	g.Source, g.TestFn = filepath.Join(g.SourceDir, "main.go"), "main.go"

	g.FileMigo = filepath.Join(g.SourceDir, "deadlock.migo")

	InstrumentMainFunc(testfile)
	if err := os.Rename(testfile, g.Source); err != nil {
		panic(err)
	}

	return g
}

func (g *DingoHunterExecuter) TestEntryAndFunc() (string, string) {
	return g.Source, g.TestFn
}

func (g *DingoHunterExecuter) Build() {}

func (g *DingoHunterExecuter) Run() *SingleRunResult {
	stage1 := fmt.Sprintf("/go/bin/dingo-hunter migo %v --output %v", g.Source, g.FileMigo)
	stage2 := fmt.Sprintf("Gong -A %v", g.FileMigo)

	result := g.next()
	result.Command = stage1 + "\n\t" + stage2
	result.process(func() {
		var err error
		var output1, output2 []byte

		args := strings.Split(stage1, " ")
		output1, err = exec.Command(args[0], args[1:]...).CombinedOutput()
		if err != nil {
			result.Logs = []byte(fmt.Sprintf("StageOne Error:\n%s\n", output1))
			result.ExitCode = 1
			return
		}
		args = strings.Split(stage2, " ")
		output2, err = exec.Command(args[0], args[1:]...).CombinedOutput()
		if err != nil {
			result.Logs = []byte(fmt.Sprintf("StageOne:\n%s\nStageTwo Error:\n%s\n", output1, output2))
			result.ExitCode = 1
			return
		}
		result.Logs = []byte(fmt.Sprintf("StageOne:\n%s\nStageTwo:\n%s\n", output1, output2))
		return
	})

	return result
}

func (g *DingoHunterExecuter) Done() {
	fulllog := g.log()
	backup := filepath.Join(g.OutputDir, "full.log")
	if err := ioutil.WriteFile(backup, []byte(fulllog), 0644); err != nil {
		panic(err)
	}
}

func (g *DingoHunterExecuter) GetResult() *BatchRunResult {
	return g.BatchRunResult
}
