package gobench

import (
	"strings"
	"testing"
	"time"
)

func shuffledBugs() []Bug {
	var result []Bug
	var bugnum int
	idxes := make(map[string]int)
	bugs := GoBenchBugSet.ListByTypes(GoRealNonBlocking | GoRealBlocking)

	bugset := NewBugSet(bugs)
	bugnum = len(bugs)
	for bugnum > 0 {
		for project, bugs := range bugset.Groups() {
			if idxes[project] < len(bugs) {
				result = append(result, bugs[idxes[project]].Fork())
				idxes[project] += 1
				bugnum -= 1
			}
		}
	}

	return result
}

func testBuildAndRunForBug(bug Bug, t *testing.T) {
	e := NewDefaultExecutor(ExecBugConfig{
		ExecEnvConfig: ExecEnvConfig{
			ClearDirs: true,
			Count:     1,
			Timeout:   5 * time.Second,
			Repeat:    2,
		},
		Bug: bug,
	}).(*GoRealExecuter)
	e.Build()
	if _, exist := FindImage(e.ImageName); !exist {
		t.Errorf("Expect %v to be exist but not found.", e.ImageName)
	}
	for i := 0; i < 2; i++ {
		e.Run()
	}
	e.Done()
	result := e.GetResult()
	if _, exist := FindContainer(e.ContainerName); exist {
		t.Errorf("Expect %v to be exited and auto-removed but still found.", e.ContainerName)
	}

	output := result.log()
	if len(output) == 0 || !strings.Contains(output, "GoBench") {
		t.Errorf("Expect a valid output. But found '%s'", output)
	}
}

func TestGoRealBasic(t *testing.T) {
	t.Skip()
	bug := GoReal("hugo_5379")
	NewGoRealBugConfig(bug, bug.gobenchCfg).UpdateDockerfile()
	testBuildAndRunForBug(bug, t)
}

func TestGoRealImageBuildAndRun(t *testing.T) {
	for _, bug := range shuffledBugs() {
		func(bug Bug) {
			t.Run(bug.ID, func(t *testing.T) {
				t.Parallel()
				defer func() {
					if err := recover(); err != nil {
						t.Errorf("%s is failed: %v", bug.ID, err)
					}
				}()
				NewGoRealBugConfig(bug, bug.gobenchCfg).UpdateDockerfile()
				// testBuildAndRunForBug(bug, t)
			})
		}(bug)
	}
}
