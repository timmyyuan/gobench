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
		ExecEnvConfig: gobench.ExecEnvConfig{
			Count:   1,
			Timeout: 5 * time.Second,
			Repeat:  2,
			PositiveCheckFunc: func(r *gobench.SingleRunResult) bool {
				return strings.Contains(string(r.Logs), "DATA RACE")
			},
		},
		Name:   "go-rd",
		Type:   gobench.GoKerNonBlocking,
		BugIDs: []string{"etcd_4876"},
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
