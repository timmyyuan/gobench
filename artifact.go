package gobench

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
)

type summary struct {
	TP  string `json:"tp"`
	FN  string `json:"fn"`
	FP  string `json:"fp"`
	Pre string `json:"pre"`
	Rec string `json:"rec"`
}

type bugSummary struct {
	Name      string    `json:"tool"`
	Summaries []summary `json:"bugs"`
	Total     summary   `json:"total"`
}

// See the description in ./gobench/<goker|goreal>/<project>/<pull id>/README.md
func manuallyCheckedFalsePositives(name string, isGoKer bool) map[string]bool {
	if isGoKer || name == "go-rd" {
		return make(map[string]bool)
	}

	result := map[string]bool{
		"kubernetes_16851": true,
		"kubernetes_30872": true,
	}
	if name == "go-deadlock" {
		result = map[string]bool{
			"cockroach_17766":  true,
			"cockroach_36367":  true,
			"etcd_7443":        true,
			"etcd_7492":        true,
			"grpc_1859":        true,
			"kubernetes_11298": true,
			"kubernetes_25331": true,
		}
	}
	return result
}

// See the description in ./gobench/<goker|goreal>/<project>/<pull id>/README.md
func manuallyCheckedFalseNegatives(name string, isGoKer bool) map[string]bool {
	if isGoKer || name != "go-rd" {
		return make(map[string]bool)
	}

	result := map[string]bool{
		"kubernetes_13058": true,
	}
	return result
}

func calculateRec(nump, numn, numf int) string {
	if nump+numn == 0 {
		return "-"
	}
	return fmt.Sprintf("%.1f", float32(nump)/float32(nump+numn)*100)
}

func calculatePre(nump, numn, numf int) string {
	if nump+numf == 0 {
		return "-"
	}
	return fmt.Sprintf("%.1f", float32(nump)/float32(nump+numf)*100)
}

func WriteToJson(suites map[string]*Suite, isGoKer bool, isBlocking bool) {
	var results []bugSummary
	names := []string{"goleak", "go-deadlock", "dingo-hunter"}
	types := []string{"Resource Deadlock", "Communication Deadlock", "Mixed Deadlock"}
	if !isBlocking {
		names = []string{"go-rd"}
		types = []string{"Traditional", "Go-Specific"}
	}
	for i := 0; i < len(names); i++ {
		if _, ok := suites[names[i]]; !ok {
			s := summary{TP: "-", FN: "-", FP: "-", Pre: "-", Rec: "-"}
			results = append(results, bugSummary{
				Name:      names[i],
				Summaries: []summary{s, s},
				Total:     s,
			})
			if isBlocking {
				results[len(results)-1].Summaries = append(results[len(results)-1].Summaries, s)
			}
			continue
		}

		falsePositives := manuallyCheckedFalsePositives(names[i], isGoKer)
		falseNegatives := manuallyCheckedFalseNegatives(names[i], isGoKer)

		report := bugSummary{
			Name: names[i],
		}

		positives := suites[names[i]].Positives()
		negatives := suites[names[i]].Negatives()

		var sump, sumf, sumn int
		for _, t := range types {
			nump := len(positives[t])
			numn := len(negatives[t])

			var numf int
			for _, bug := range positives[t] {
				if _, ok := falsePositives[bug.ID]; ok {
					numf++
				}
			}
			nump -= numf

			for _, bug := range negatives[t] {
				if _, ok := falseNegatives[bug.ID]; ok {
					numn += 1
					nump -= 1
				}
			}

			report.Summaries = append(report.Summaries, summary{
				TP:  strconv.Itoa(nump),
				FN:  strconv.Itoa(numn),
				FP:  strconv.Itoa(numf),
				Pre: calculatePre(nump, numn, numf),
				Rec: calculateRec(nump, numn, numf),
			})

			sump += nump
			sumn += numn
			sumf += numf
		}

		report.Total = summary{
			TP:  strconv.Itoa(sump),
			FN:  strconv.Itoa(sumn),
			FP:  strconv.Itoa(sumf),
			Pre: calculatePre(sump, sumn, sumf),
			Rec: calculateRec(sump, sumn, sumf),
		}

		results = append(results, report)
	}

	filename := "table4"
	if !isBlocking {
		filename = "table5"
	}
	if isGoKer {
		filename += ".goker.json"
	} else {
		filename += ".goreal.json"
	}

	data := make(map[string]bugSummary)
	for _, r := range results {
		data[r.Name] = r
	}

	dir := filepath.Join(GOBENCH_ROOT_PATH, "result")
	if IsNotExists(dir) {
		err := os.Mkdir(dir, 0700)
		if err != nil {
			panic(err)
		}
	}

	file := filepath.Join(".", "result", filename)
	b, _ := json.MarshalIndent(&data, "", "\t")
	ioutil.WriteFile(file, b, 0644)
}

func CountValueForFig10(suite *Suite) []float64 {
	values := []float64{0, 0, 0, 0}
	var bugs []Bug
	for _, v := range suite.Positives() {
		bugs = append(bugs, v...)
	}
	for _, bug := range bugs {
		res := suite.GetResult(bug.ID)
		num := res.FailFirstIfPositive()
		if num <= 1 {
			values[0] += 1
		} else if num > 1 && num <= 100 {
			values[1] += 1
		} else if num > 100 && num <= 1000 {
			values[2] += 1
		} else {
			values[3] += 1
		}
	}
	return values
}

func PlotFig10(suites map[string]*Suite, isGoKer bool) {
	names := []string{"goleak", "go-deadlock", "go-rd"}

	values := [][]float64{}
	for i := 0; i < len(names); i++ {
		values = append(values, []float64{0, 0, 0, 0})
		var bugs []Bug
		for _, v := range suites[names[i]].Positives() {
			bugs = append(bugs, v...)
		}
		for _, bug := range bugs {
			res := suites[names[i]].GetResult(bug.ID)
			num := res.FailFirstIfPositive()
			if num <= 1 {
				values[i][0] += 1
			} else if num > 1 && num <= 100 {
				values[i][1] += 1
			} else if num > 100 && num <= 1000 {
				values[i][2] += 1
			} else {
				values[i][3] += 1
			}
		}
	}

	groups := make(map[string][]float64)
	ranges := []string{"(0, 1]", "(1, 100]", "(100, 1000]", "(1000, +]"}
	for i := 0; i < 4; i++ {
		groups[ranges[i]] = []float64{values[0][i], values[1][i], values[2][i]}
	}

	b, _ := json.MarshalIndent(&groups, "", "\t")

	file := "./result/fig10.goker.json"
	if !isGoKer {
		file = "./result/fig10.goreal.json"
	}
	ioutil.WriteFile(file, b, 0644)

	cmd := exec.Command("python3", "plot.py")
	cmd.Dir = GOBENCH_ROOT_PATH
	if out, err := cmd.CombinedOutput(); err != nil {
		log.Println(string(out))
		panic(string(out))
	}
}
