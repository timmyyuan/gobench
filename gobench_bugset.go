package gobench

import (
	"fmt"
	"strings"
	"sync"
)

type BugSet struct {
	sync.RWMutex

	idToBugs map[string][]Bug
	pjToBugs map[string][]Bug
	tyToBugs map[SubBenchType][]Bug
}

func NewBugSet(bugs []Bug) *BugSet {
	s := &BugSet{
		idToBugs: make(map[string][]Bug),
		pjToBugs: make(map[string][]Bug),
		tyToBugs: make(map[SubBenchType][]Bug),
	}

	for _, bug := range bugs {
		s.idToBugs[bug.ID] = append(s.idToBugs[bug.ID], bug)
		s.tyToBugs[bug.Type] = append(s.tyToBugs[bug.Type], bug)

		project, _ := SplitBugID(bug.ID)
		s.pjToBugs[project] = append(s.pjToBugs[project], bug)
	}

	return s
}

func (s *BugSet) String() string {
	var bugids []string
	bugs := s.Bugs()
	for _, bug := range bugs {
		bugids = append(bugids, bug.ID)
	}
	return fmt.Sprintf("[%s]", strings.Join(bugids, ", "))
}

func (s *BugSet) List() (result []string) {
	s.RLock()
	defer s.RUnlock()
	for id, _ := range s.idToBugs {
		result = append(result, id)
	}
	return
}

func (s *BugSet) Bugs() (result []Bug) {
	s.RLock()
	defer s.RUnlock()
	for _, bugs := range s.idToBugs {
		result = append(result, bugs...)
	}
	return
}

func (s *BugSet) Groups() map[string][]Bug {
	s.RLock()
	defer s.RUnlock()
	return s.pjToBugs
}

func (s *BugSet) ListByTypes(lhs SubBenchType) []Bug {
	var bugs []Bug
	pushback := func(rhs SubBenchType) {
		if lhs&rhs != 0 {
			bugs = append(bugs, s.tyToBugs[rhs]...)
		}
	}
	s.RLock()
	defer s.RUnlock()
	pushback(GoKerBlocking)
	pushback(GoKerNonBlocking)
	pushback(GoRealBlocking)
	pushback(GoRealNonBlocking)
	return bugs
}
