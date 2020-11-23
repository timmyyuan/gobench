package gobench

import (
	"io/ioutil"
	"path/filepath"
	"testing"
	"time"
)

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
