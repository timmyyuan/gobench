package gobench

import (
	"fmt"
	"strings"
	"time"
)

var OutputFormatStr = `
========================= GoBench =========================
Subtype   : %-20v	BugID : %-8v
IsBlocking: %-20v	Repeat: %-8v

Start  :  %v
Finish :  %v

WorkDir:  %s
Command:  %s
===========================================================

%s
`

type SingleRunResult struct {
	ExecBugConfig

	ExitCode int
	Logs     []byte
	Command  string

	index      int
	timeCost   time.Duration
	timeStart  time.Time
	timeFinish time.Time
	FailFirst  float64
}

func (r *SingleRunResult) log() string {
	return fmt.Sprintf(OutputFormatStr, r.Bug.Type, r.Bug.ID, r.Bug.isBlocking(), r.index,
		r.timeStart, r.timeFinish, r.SourceDir, r.Command, r.Logs)
}

func (r *SingleRunResult) process(fn func()) {
	r.timeStart = time.Now()
	fn()
	r.timeFinish = time.Now()
	r.timeCost = r.timeFinish.Sub(r.timeStart)

	if r.ExitCode != 0 {
		r.FailFirst = float64(strings.Count(r.log(), "--- PASS:")) + 1
	}
}

type BatchRunResult struct {
	ExecBugConfig
	results []*SingleRunResult
}

func (r *BatchRunResult) next() *SingleRunResult {
	result := &SingleRunResult{
		ExecBugConfig: r.ExecBugConfig,
		index:         len(r.results),
	}
	r.results = append(r.results, result)
	return result
}

func (r *BatchRunResult) log() string {
	var outputs []string
	for _, i := range r.results {
		outputs = append(outputs, i.log())
	}
	return strings.Join(outputs, "\n")
}

func (r *BatchRunResult) FailFirst() float64 {
	var cnt float64
	for _, i := range r.results {
		if i.FailFirst == 0 {
			cnt += 100000
		} else {
			cnt += i.FailFirst
		}
	}
	return cnt / float64(len(r.results))
}

func (r *BatchRunResult) TimeCost() time.Duration {
	var cnt time.Duration
	for _, i := range r.results {
		cnt += i.timeCost
	}
	return cnt
}

func (r *BatchRunResult) FailedNum() (sum int) {
	for _, i := range r.results {
		if i.ExitCode != 0 {
			sum += 1
		}
	}
	return
}

func (r *BatchRunResult) FailureRate() float64 {
	return float64(r.FailedNum()) / float64(r.Repeat) * 100
}

func (r *BatchRunResult) exitcode() int {
	for _, i := range r.results {
		if i.ExitCode != 0 {
			return 1
		}
	}
	return 0
}

func (r *BatchRunResult) IsPositive() bool {
	chkFunc := func(s *SingleRunResult) bool {
		return s.ExitCode != 0
	}
	if r.PositiveCheckFunc != nil {
		chkFunc = r.PositiveCheckFunc
	}
	for _, i := range r.results {
		if chkFunc(i) {
			return true
		}
	}
	return false
}

func (r *BatchRunResult) IsNegative() bool {
	if r.NegativeCheckFunc == nil && r.PositiveCheckFunc != nil {
		return !r.IsPositive()
	}

	chkFunc := func(s *SingleRunResult) bool {
		return s.ExitCode != 0
	}
	if r.NegativeCheckFunc != nil {
		chkFunc = r.NegativeCheckFunc
	}
	for _, i := range r.results {
		if chkFunc(i) {
			return true
		}
	}
	return false
}

func (r *BatchRunResult) FailFirstIfPositive() float64 {
	if !r.IsPositive() {
		return 0
	}
	var cnt, total float64
	for _, i := range r.results {
		if r.PositiveCheckFunc(i) {
			cnt += i.FailFirst
			total += 1
		}
		/*else {
			cnt += float64(r.Count)
		}*/
	}
	// return cnt / float64(len(r.results))
	return cnt / total
}
