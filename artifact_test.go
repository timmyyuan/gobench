package gobench

import (
	"log"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
	"time"
)

func defaultJobs() int {
	return runtime.GOMAXPROCS(0)
}

func defaultExecEnvConfig(name string, t SubBenchType) ExecEnvConfig {
	config := ExecEnvConfig{
		ClearDirs: true,
		Count:     100000,
		Timeout:   20 * time.Minute,
		Repeat:    10,
	}
	switch name {
	case "goleak":
		config.PositiveCheckFunc = func(r *SingleRunResult) bool {
			return strings.Contains(string(r.Logs), "found unexpected goroutines")
		}
		config.Tag = "goleak"
		config.BugConfigPath = filepath.Join(BackupPath, "configures", "goreal", "blocking.goleak.json")
	case "go-deadlock":
		config.PositiveCheckFunc = func(r *SingleRunResult) bool {
			return strings.Contains(string(r.Logs), "POTENTIAL DEADLOCK:")
		}
		config.Tag = "go-deadlock"
		config.BugConfigPath = filepath.Join(BackupPath, "configures", "goreal", "blocking.go-deadlock.json")
	case "dingo-hunter":
		config.PositiveCheckFunc = func(r *SingleRunResult) bool {
			return strings.Contains(string(r.Logs), "False")
		}
		config.Tag = "dingo-hunter"
	case "go-rd":
		config.PositiveCheckFunc = func(r *SingleRunResult) bool {
			return strings.Contains(string(r.Logs), "DATA RACE")
		}
		config.Tag = "go-rd"
		config.BugConfigPath = filepath.Join(BackupPath, "configures", "goreal", "nonblocking.json")
	}

	return config
}

func defaultSuiteConfig(name string, t SubBenchType) SuiteConfig {
	ret := SuiteConfig{
		ExecEnvConfig: defaultExecEnvConfig(name, t),
		Type:          t,
		Name:          name,
		MustFork:      true,
		Jobs:          defaultJobs(),
	}
	if t&GoKerBlocking | t &GoKerNonBlocking != 0 {
		ret.Timeout = 10 * time.Minute // 10 minutes is enough
	}
	if name == "dingo-hunter" {
		/// ExecEnvConfig is useless for dingo-hunter
		ret.Count = 1
		ret.Repeat = 1
		ret.ExecutorCreator = func(config ExecBugConfig) Executor {
			return newDingoHunterExecuter(config)
		}
	}
	return ret
}

func simplifyConfig(config SuiteConfig, ids []string) SuiteConfig {
	config.Count = 2
	config.Repeat = 2
	config.Timeout = 5 * time.Second
	config.BugIDs = ids
	return config
}

func TestMain(m *testing.M) {
	dir := filepath.Join(os.TempDir(), "gobench")
	if IsNotExists(dir) {
		if err := os.Mkdir(dir, 0700); err != nil {
			panic(err)
		}
	}
	m.Run()
}


func TestArtifactGoKer(t *testing.T) {
	tests := []struct {
		Name      string
		Type      SubBenchType
		SetUpFunc func(suite *Suite)
	}{
		{
			"go-rd",
			GoKerNonBlocking,
			func(suite *Suite) {},
		},
		{
			"goleak",
			GoKerBlocking,
			func(suite *Suite) {
				var tasks []func()
				for _, file := range suite.TestFiles() {
					file := file
					tasks = append(tasks, func() {
						InstrumentGoleak(file)
					})
				}
				BatchJobs(tasks, defaultJobs())
			},
		},
		{
			"go-deadlock",
			GoKerBlocking,
			func(suite *Suite) {
				var tasks []func()
				for _, file := range suite.TestFiles() {
					file := file
					tasks = append(tasks, func() {
						InstrumentGoDeadlock(file)
					})
				}
				BatchJobs(tasks, defaultJobs())
			},
		},
		{
			"dingo-hunter",
			GoKerBlocking,
			func(suite *Suite) {},
		},
	}

	suites := make(map[string]*Suite)
	for _, test := range tests {
		log.Println("Start suite ", test.Name)
		suite := NewSuite(defaultSuiteConfig(test.Name, test.Type))
		suite.SetUpFunc = func() {
			test.SetUpFunc(suite)
		}
		suite.Run()
		suites[suite.Name] = suite
		log.Println("Done suite ", test.Name)
	}

	WriteToJson(suites, true, true)
	WriteToJson(suites, true, false)
	PlotFig10(suites, true)
}

func TestArtifactGoReal(t *testing.T) {
	tests := []struct {
		Name string
		Type SubBenchType
	}{
		{
			"go-rd",
			GoRealNonBlocking,
		},
		{
			"goleak",
			GoRealBlocking,
		},
		{
			"go-deadlock",
			GoRealBlocking,
		},
	}
	suites := make(map[string]*Suite)
	for _, test := range tests {
		log.Println("Start suite ", test.Name)
		suite := NewSuite(defaultSuiteConfig(test.Name, test.Type))
		suite.Run()
		suites[suite.Name] = suite
		log.Println("Done suite ", test.Name)
	}

	WriteToJson(suites, false, false)
	WriteToJson(suites, false, true)
	PlotFig10(suites, false)
}

func TestArtifactSimpleSpecific(t *testing.T) {
	config := defaultSuiteConfig("goleak", GoRealBlocking)
	config.BugIDs = []string{"kubernetes_11298"}
	s := NewSuite(config)
	s.Run()
	log.Println(CountValueForFig10(s))
}

func TestArtifactSimpleRace( t *testing.T) {
	suite := NewSuite(defaultSuiteConfig("go-rd", GoRealNonBlocking))
	suite.Run()
	log.Println(CountValueForFig10(suite))
}

func TestArtifactSimpleGoReal(t *testing.T) {
	tests := []struct {
		Name   string
		Type   SubBenchType
		BugIDs []string
	}{
		{
			"goleak",
			GoRealBlocking,
			[]string{"grpc_795"},
		},
		{
			"go-deadlock",
			GoRealBlocking,
			[]string{"kubernetes_16851"},
		},
		{
			"go-rd",
			GoRealNonBlocking,
			[]string{"etcd_4876"},
		},
	}

	suitesGoReal := make(map[string]*Suite)
	for _, test := range tests {
		suite := NewSuite(simplifyConfig(defaultSuiteConfig(test.Name, test.Type), test.BugIDs))
		suite.Run()
		suitesGoReal[suite.Name] = suite
	}

	WriteToJson(suitesGoReal, false, true)
	WriteToJson(suitesGoReal, false, false)

	PlotFig10(suitesGoReal, false)
}

func TestArtifactSimpleGoKer(t *testing.T) {
	tests := []struct {
		Name      string
		Type      SubBenchType
		BugIDs    []string
		SetUpFunc func(suite *Suite)
	}{
		{
			"goleak",
			GoKerBlocking,
			[]string{"grpc_795"},
			func(suite *Suite) {
				for _, file := range suite.TestFiles() {
					InstrumentGoleak(file)
				}
			},
		},
		{
			"go-deadlock",
			GoKerBlocking,
			[]string{"kubernetes_6632"},
			func(suite *Suite) {
				for _, file := range suite.TestFiles() {
					InstrumentGoDeadlock(file)
				}
			},
		},
		{
			"go-rd",
			GoKerNonBlocking,
			[]string{"etcd_4876"},
			nil,
		},
		{
			"dingo-hunter",
			GoKerBlocking,
			[]string{},
			nil,
		},
	}

	suitesGoker := make(map[string]*Suite)
	for _, test := range tests {
		suite := NewSuite(simplifyConfig(defaultSuiteConfig(test.Name, test.Type), test.BugIDs))
		if test.SetUpFunc != nil {
			suite.SetUpFunc = func() {
				test.SetUpFunc(suite)
			}
		}
		suite.Run()
		suitesGoker[suite.Name] = suite
	}

	WriteToJson(suitesGoker, true, true)
	WriteToJson(suitesGoker, true, false)

	PlotFig10(suitesGoker, true)
}
