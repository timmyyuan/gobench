package gobench

import (
	"io/ioutil"
	"path/filepath"
	"testing"
	"strings"
	"time"
)

func TestGoKerWithSuite(t *testing.T) {
	bugid := "etcd_4876"
	s := NewSuite(SuiteConfig{
		ExecEnvConfig: ExecEnvConfig{
			Count:   1,
			Timeout: 5 * time.Second,
			Repeat:  2,
			PositiveCheckFunc: func(r *SingleRunResult) bool {
				return strings.Contains(string(r.Logs), "DATA RACE")
			},
		},
		Name:   "go-rd",
		Type:   GoKerNonBlocking,
		BugIDs: []string{bugid},
	})

	s.Run()

	result := s.GetResult(bugid)

	if !result.IsPositive() {
		t.Fatalf("Expect the test of %s being positive\n", bugid)
	}

	logfile := filepath.Join(result.OutputDir, "full.log")
	out, err := ioutil.ReadFile(logfile)
	if err != nil {
		t.Fatal(err)
	}

	if !strings.Contains(string(out), "DATA RACE") {
		t.Fatal("Expect 'DATA RACE' in the full log file", " ", logfile)
	}
}

func TestGoKerSingleTestToRun(t *testing.T) {
	tests := []string{"hugo_5379"}
	for _, bugid := range tests {
		bug := GoKer(bugid)
		config := ExecBugConfig{
			ExecEnvConfig: ExecEnvConfig{
				ClearDirs: true,
				Count:     1,
				Cpu:       0,
				Timeout:   1 * time.Second,
				Repeat:    1,
			},
			Bug: bug,
		}
		e := NewDefaultExecutor(config).(*GoKerExecuter)

		file, fname := e.TestEntryAndFunc()
		expect := filepath.Join(e.Bug.forkedPath, "hugo5379_test.go")
		if file != expect {
			t.Fatalf("Expect '%s' but found '%s'\n", expect, file)
		}

		if fname != "TestHugo5379" {
			t.Fatalf("Expect 'TestHugo5379' but found '%s'.\n", fname)
		}

		// Build a executor
		e.Build()

		// Execute only once
		e.Run()

		// Flash the result to disk
		e.Done()
		backup := filepath.Join(e.OutputDir, "full.log")
		out, err := ioutil.ReadFile(backup)
		if err != nil {
			t.Fatal(err)
		}
		if len(out) == 0 {
			t.Fatal("Expect a newline but found nothing in ", backup)
		}
	}
}
