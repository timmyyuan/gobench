package gobench

import (
	"fmt"
	"log"
	"path/filepath"
	"runtime"
	"sync"
)

type SuiteConfig struct {
	ExecEnvConfig
	Name string

	Type     SubBenchType
	BugIDs   []string
	MustFork bool
	Jobs     int

	ExecutorCreator func(config ExecBugConfig) Executor

	SetUpFunc    func()
	ShutDownFunc func()
}

type Suite struct {
	SuiteConfig
	BugSet *BugSet

	executors sync.Map
}

func NewSuite(config SuiteConfig) *Suite {
	s := &Suite{
		SuiteConfig: config,
	}

	var bugs []Bug
	allBugs := GoBenchBugSet.ListByTypes(s.Type)
	if len(s.BugIDs) == 0 {
		bugs = allBugs
	} else {
		for _, b := range allBugs {
			for _, id := range s.BugIDs {
				if id != b.ID {
					continue
				}

				bugs = append(bugs, b)
				break
			}
		}
	}

	workdir := s.WorkDir()

	for i := range bugs {
		bugs[i].fork(workdir)
	}
	s.BugSet = NewBugSet(bugs)

	for _, bug := range s.BugSet.Bugs() {
		if bug.isGoReal() {
			NewGoRealBugConfig(bug, s.BugConfigPath).UpdateDockerfile()
		}
	}

	return s
}

func (s *Suite) WorkDir() string {
	return filepath.Join(filepath.Dir(BackupPath), "evaluation", fmt.Sprintf("gobench-%s", s.Name))
}

func (s *Suite) build() {
	bugs := s.BugSet.Bugs()
	var tasks []func()
	for _, bug := range bugs {
		bug := bug
		tasks = append(tasks, func() {
			execConfig := ExecBugConfig{
				ExecEnvConfig: s.ExecEnvConfig,
				Bug:           bug,
				SourceDir:     bug.forkedPath,
				OutputDir:     bug.forkedPath,
			}
			var executor Executor
			if s.ExecutorCreator != nil {
				executor = s.ExecutorCreator(execConfig)
			} else {
				executor = NewDefaultExecutor(execConfig)
			}
			executor.Build()
			s.executors.Store(bug.ID, executor)
		})
	}

	if !BatchJobs(tasks, runtime.GOMAXPROCS(0)) {
		panic(fmt.Sprintf("ERROR: This suite %s was failed in building.\n", s.BugSet))
	}
}

func (s *Suite) Run() {
	if s.SetUpFunc != nil {
		s.SetUpFunc()
	}

	s.build()

	if s.ShutDownFunc != nil {
		defer s.ShutDownFunc()
	}

	if s.Jobs == 1 {
		s.executors.Range(func(bugid interface{}, executor interface{}) bool {
			for i := 0; i < s.Repeat; i++ {
				executor.(Executor).Run()
			}
			executor.(Executor).Done()
			return true
		})
		return
	}

	var tasks []func()
	s.executors.Range(func(bugid interface{}, executor interface{}) bool {
		worker := executor.(Executor)
		tasks = append(tasks, func() {
			for i := 0; i < s.Repeat; i++ {
				worker.Run()
			}
			worker.Done()
		})
		return true
	})

	// FIXME: change to context.Timeout here
	if !BatchJobs(tasks, s.Jobs) {
		log.Printf("WARNING: This suite %s was not finished.\n", s.BugSet)
	}
}

func (s *Suite) TestFiles() (files []string) {
	if (s.Type&GoRealBlocking)|(s.Type&GoRealNonBlocking) != 0 {
		panic("Not implement yet")
	}
	for _, bug := range s.BugSet.Bugs() {
		project, id := SplitBugID(bug.ID)
		testfile := fmt.Sprintf("%s%s_test.go", project, id)
		files = append(files, filepath.Join(bug.Dir(), testfile))
	}
	return
}

func (s *Suite) GetResult(bugid string) *BatchRunResult {
	if e, exist := s.executors.Load(bugid); exist {
		return e.(Executor).GetResult()
	}
	panic(fmt.Errorf("Can't find %s in %s", bugid, s.BugSet))
}

func (s *Suite) Positives() map[string][]Bug {
	results := make(map[string][]Bug)
	bugs := s.BugSet.Bugs()
	for _, bug := range bugs {
		if s.GetResult(bug.ID).IsPositive() {
			results[bug.SubType] = append(results[bug.SubType], bug)
		}
	}
	return results
}

func (s *Suite) Negatives() map[string][]Bug {
	results := make(map[string][]Bug)
	bugs := s.BugSet.Bugs()
	for _, bug := range bugs {
		if s.GetResult(bug.ID).IsNegative() {
			results[bug.SubType] = append(results[bug.SubType], bug)
		}
	}
	return results
}
