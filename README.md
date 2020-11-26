# GoBench

GoBench is the first benchmark suite for Go concurrency bugs. Currently, 
GoBench consists of 82 real bugs from 9 popular open source applications 
and 103 bug kernels. The bug kernels are carefully extracted and 
simplified from 67 out of these 82 bugs and 36 additional bugs reported 
in a recent study to preserve their bug-inducing complexities as much as 
possible. These bugs cover a variety of concurrency issues, both 
traditional and Go-specific. We believe GoBench will be instrumental in 
helping researchers understand concurrency bugs in Go and develop 
effective tools for their detection.

More detailed descriptions can be found in [README.md](./gobench/README.md)

## Artifact evaluation in our CGO 2021 paper

To evaluation, run

```sh
make all
```

Results can be found in [artifact.pdf]

[artifact.pdf]:artifact.pdf

## Call GoBench in Go

There is a example for calling GoBench in Go

```go
package main

import (
	"fmt"
	"github.com/timmyyuan/gobench"
	"path/filepath"
    "strings"
	"time"
)

func main() {
	s := gobench.NewSuite(gobench.SuiteConfig{
		ExecEnvConfig:   gobench.ExecEnvConfig{
			Count:             1,
			Timeout:           5 * time.Second,
			Repeat:            2,
			PositiveCheckFunc: func(r *gobench.SingleRunResult) bool {
				return strings.Contains(string(r.Logs), "DATA RACE")
			},
		},
		Name:            "go-rd",
		Type:            gobench.GoKerNonBlocking,
		BugIDs:          []string{"etcd_4876"},
		SetUpFunc: func() {
			// You can do some changes for etcd_4876 here before start the suite.
		},
	})
	
	s.Run()

	result := s.GetResult("etcd_4876")
    fmt.Printf("etcd_4876 logs -> %s\n", filepath.Join(result.OutputDir, "full.log"))

	if result.IsPositive() {
		fmt.Println("OK, we reproduced etcd_4876 in GoBench (GoKer)")
	} else {
		fmt.Println("Sorry, we failed to reproduce etcd_4876 in GoBench (GoKer)")
	}
}
```
