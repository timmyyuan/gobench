package gobench

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
)

type GoKerExecuter struct {
	*BatchRunResult
	Binary string
	Source string
	TestFn string
}

func newGoKerExecuter(config ExecBugConfig) *GoKerExecuter {
	g := &GoKerExecuter{
		BatchRunResult: &BatchRunResult{
			ExecBugConfig: config,
		},
	}

	tmpfile, err := ioutil.TempFile("", g.Bug.ID+"_*")
	if err != nil {
		panic(err)
	}
	g.Binary = tmpfile.Name()

	project, id := SplitBugID(g.Bug.ID)
	testfile := filepath.Join(g.SourceDir, fmt.Sprintf("%s%s_test.go", project, id))
	r, _ := regexp.Compile("func Test(.*)\\(t \\*testing\\.T\\)")
	code, err := ioutil.ReadFile(testfile)
	if err != nil {
		panic(err)
	}
	testfunc := strings.Split(string(r.Find(code)), " ")[1]
	bound := strings.Index(testfunc, "(")
	g.Source, g.TestFn = testfile, testfunc[0:bound]

	return g
}

func (g *GoKerExecuter) TestEntryAndFunc() (string, string) {
	return g.Source, g.TestFn
}

func (g *GoKerExecuter) Build() {
	build := "test -c %v -o %v"
	if g.Bug.Type == GoKerNonBlocking {
		build += " -race"
	}
	source, _ := g.TestEntryAndFunc()
	args := strings.Split(fmt.Sprintf(build, source, g.Binary), " ")
	if out, err := exec.Command("go", args...).CombinedOutput(); err != nil {
		panic(fmt.Sprintln(string(out), "\n", err))
	}
}

func (g *GoKerExecuter) Run() *SingleRunResult {
	command := "%v -test.v -test.count %v -test.failfast -test.timeout %v"
	vals := []interface{}{g.Binary, g.Count, g.Timeout}
	if g.Cpu != 0 {
		command += " -test.cpu %v"
		vals = append(vals, g.Cpu)
	}
	args := strings.Split(fmt.Sprintf(command, vals...), " ")

	result := g.next()
	result.Command = strings.Join(args, " ")
	result.process(func() {
		var err error
		result.Logs, err = exec.Command(args[0], args[1:]...).CombinedOutput()
		if err != nil {
			result.ExitCode = 1
		}
	})

	return result
}

func (g *GoKerExecuter) Done() {
	fulllog := g.log()
	backup := filepath.Join(g.OutputDir, "full.log")
	if err := ioutil.WriteFile(backup, []byte(fulllog), 0644); err != nil {
		panic(err)
	}

	if g.ClearDirs {
		if err := os.Remove(g.Binary); err != nil {
			panic(err)
		}
	}
}

func (g *GoKerExecuter) GetResult() *BatchRunResult {
	return g.BatchRunResult
}
