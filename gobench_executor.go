package gobench

import (
	"log"
	"os"
	"time"
)

type Executor interface {
	Build()
	Run() *SingleRunResult
	Done()
	GetResult() *BatchRunResult
	TestEntryAndFunc() (string, string)
}

type ExecEnvConfig struct {
	BugConfigPath string

	ClearDirs         bool
	Tag               string // for GoReal only
	Count             int
	Cpu               int
	Timeout           time.Duration
	Repeat            int
	PositiveCheckFunc func(r *SingleRunResult) bool
	NegativeCheckFunc func(r *SingleRunResult) bool
}

type ExecBugConfig struct {
	ExecEnvConfig
	Bug Bug

	SourceDir string // source directory of a bug
	OutputDir string // output directory of an execution
}

func NewDefaultExecutor(config ExecBugConfig) Executor {
	if config.SourceDir == "" {
		config.SourceDir = config.Bug.forkedPath
	}

	if config.OutputDir == "" {
		config.OutputDir = config.Bug.forkedPath
	}

	if IsNotExists(config.OutputDir) {
		if err := os.MkdirAll(config.OutputDir, 0775); err != nil {
			log.Println(config.OutputDir)
			panic(err)
		}
	}

	if config.Bug.isGoReal() {
		return newGoRealExecuter(config)
	}

	return newGoKerExecuter(config)
}
