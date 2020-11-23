package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

type Data struct {
	CreatedTime string

	GoKerFig10  string
	GoRealFig10 string

	ItemsGoRealResDeadlock   []string
	ItemsGoRealComDeadlock   []string
	ItemsGoRealMixDeadlock   []string
	ItemsGoRealBlockingTotal []string

	ItemsGoKerResDeadlock   []string
	ItemsGoKerComDeadlock   []string
	ItemsGoKerMixDeadlock   []string
	ItemsGoKerBlockingTotal []string

	ItemsGoRealTraditional      []string
	ItemsGoRealGoSpecifiic      []string
	ItemsGoRealNonBlockingTotal []string

	ItemsGoKerTraditional      []string
	ItemsGoKerGoSpecifiic      []string
	ItemsGoKerNonBlockingTotal []string
}

type Summary struct {
	TP  string `json:"tp"`
	FN  string `json:"fn"`
	FP  string `json:"fp"`
	Pre string `json:"pre"`
	Rec string `json:"rec"`
}

type Entry struct {
	Tool  string    `json:"tool"`
	Bugs  []Summary `json:"bugs"`
	Total Summary   `json:"total"`
}

func load(filename string) map[string]Entry {
	bytes, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	var entry map[string]Entry
	err = json.Unmarshal(bytes, &entry)
	if err != nil {
		panic(err)
	}

	return entry
}

func newdata() Data {
	d := Data{}

	root := filepath.Join(os.Getenv("GOBENCH_ROOT_PATH"), "result")
	figs := []string{
		"fig10.goreal.png",
		"fig10.goker.png",
	}

	d.GoRealFig10 = filepath.Join(".", figs[0])
	d.GoKerFig10 = filepath.Join(".", figs[1])

	files := []string{
		filepath.Join(root, "table4.goreal.json"),
		filepath.Join(root, "table4.goker.json"),
		filepath.Join(root, "table5.goreal.json"),
		filepath.Join(root, "table5.goker.json"),
	}

	tools := []string{"goleak", "go-deadlock", "dingo-hunter", "go-rd"}
	tostrs := func(s Summary) []string {
		return []string{s.TP, s.FN, s.FP, s.Pre, s.Rec}
	}

	var rows [][]string
	for f := 0; f < len(files); f++ {
		data := load(files[f])
		size := 3
		if f > 1 {
			size = 2
		}
		for i := 0; i < size; i++ {
			var row []string
			for _, tool := range tools {
				if _, ok := data[tool]; !ok {
					continue
				}
				row = append(row, tostrs(data[tool].Bugs[i])...)
			}
			rows = append(rows, row)
		}
		var row []string
		for _, tool := range tools {
			if _, ok := data[tool]; !ok {
				continue
			}
			row = append(row, tostrs(data[tool].Total)...)
		}
		rows = append(rows, row)
	}

	d.ItemsGoRealResDeadlock = rows[0]
	d.ItemsGoRealComDeadlock = rows[1]
	d.ItemsGoRealMixDeadlock = rows[2]
	d.ItemsGoRealBlockingTotal = rows[3]

	d.ItemsGoKerResDeadlock = rows[4]
	d.ItemsGoKerComDeadlock = rows[5]
	d.ItemsGoKerMixDeadlock = rows[6]
	d.ItemsGoKerBlockingTotal = rows[7]

	d.ItemsGoRealTraditional = rows[8]
	d.ItemsGoRealGoSpecifiic = rows[9]
	d.ItemsGoRealNonBlockingTotal = rows[10]

	d.ItemsGoKerTraditional = rows[11]
	d.ItemsGoKerGoSpecifiic = rows[12]
	d.ItemsGoKerNonBlockingTotal = rows[13]

	d.CreatedTime = fmt.Sprintf("%v", time.Now())

	return d
}

func main() {
	root := filepath.Join(os.Getenv("GOBENCH_ROOT_PATH"), "cmd", "pdf")

	t, err := template.ParseFiles(filepath.Join(root, "index.template"))
	if err != nil {
		panic(err)
	}

	site := filepath.Join(root, "index.html")
	if _, err := os.Stat(site); err == nil {
		if err := os.Remove(site); err != nil {
			panic(err)
		}
	}

	index, err := os.OpenFile(site, os.O_WRONLY|os.O_CREATE, 0644)
	if err != nil {
		panic(err)
	}
	defer index.Close()

	err = t.Execute(index, newdata())
	if err != nil {
		panic(err)
	}

	/*
	fs := http.FileServer(http.Dir(root))
	http.Handle("/", fs)

	log.Println("Listening on :2021...")
	err = http.ListenAndServe(":2021", nil)
	if err != nil {
		log.Fatal(err)
	}
	 */

	output := filepath.Join(os.Getenv("GOBENCH_ROOT_PATH"), "artifact.pdf")
	if out, err := exec.Command("wkhtmltopdf", "index.html", output).CombinedOutput(); err != nil {
		panic(fmt.Errorf("ERROR : %v \n LOGS:\n %s", err, out))
	}
}
