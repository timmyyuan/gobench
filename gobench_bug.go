package gobench

import (
	"encoding/json"
	"fmt"
	"github.com/zloylos/grsync"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

var BackupPath, ConfigPath, TestPath string
var GoBenchBugSet *BugSet

func init() {
	log.SetFlags(log.Llongfile)
	BackupPath = filepath.Join(os.Getenv("GOBENCH_ROOT_PATH"), "gobench")
	TestPath = filepath.Join(os.Getenv("GOBENCH_ROOT_PATH"), "gobench-test")
	GoBenchBugSet = newGoBench()
}

type bugTypeInfo struct {
	Subtype    string `json:"type"`
	Subsubtype string `json:"subtype"`
}

func compeletTypeInfo(bug Bug, path string) Bug {
	b, err := ioutil.ReadFile(path)
	if err != nil {
		panic(err)
	}

	var result map[string]*bugTypeInfo
	if err := json.Unmarshal(b, &result); err != nil {
		panic(err)
	}

	obj, ok := result[bug.ID]
	if !ok {
		msg := "%s not in %s. Please add the configuration of %s to %s"
		panic(fmt.Errorf(msg, bug.ID, path, bug.ID, path))
	}
	bug.SubType = obj.Subtype
	bug.SubSubType = obj.Subsubtype
	return bug
}

func newGoBench() *BugSet {
	types := [][]string{
		[]string{"goker", "blocking"},
		[]string{"goker", "nonblocking"},
		[]string{"goreal", "blocking"},
		[]string{"goreal", "nonblocking"},
	}
	getpath := func(subtype, subsubtype string) string {
		return filepath.Join(BackupPath, subtype, subsubtype)
	}
	getcfg := func(subtype, subsubtype string) string {
		return filepath.Join(BackupPath, "configures", subtype, subsubtype+".json")
	}

	var bugs []Bug
	for i := 0; i < len(types); i++ {
		subtype := types[i][0]
		subsubtype := types[i][1]
		root := getpath(subtype, subsubtype)
		cfg := getcfg(subtype, subsubtype)
		projects, err := ioutil.ReadDir(root)
		if err != nil {
			panic(err)
		}

		for _, p := range projects {
			bugids, err := ioutil.ReadDir(filepath.Join(root, p.Name()))
			if err != nil {
				panic(err)
			}
			for _, id := range bugids {
				bugs = append(bugs, compeletTypeInfo(Bug{
					ID:         p.Name() + "_" + id.Name(),
					Type:       toSubBenchType(subtype, subsubtype),
					frozenPath: filepath.Join(root, p.Name(), id.Name()),
					gobenchCfg: cfg,
				}, cfg))
			}
		}
	}

	return NewBugSet(bugs)
}

type SubBenchType int

const (
	GoKerBlocking SubBenchType = 1 << iota
	GoKerNonBlocking
	GoRealBlocking
	GoRealNonBlocking
)

func toSubBenchType(sub string, subsub string) SubBenchType {
	types := []SubBenchType{
		GoKerBlocking,
		GoKerNonBlocking,
		GoRealBlocking,
		GoRealNonBlocking,
	}
	for _, t := range types {
		if t.String() == filepath.Join(sub, subsub) {
			return t
		}
	}
	panic("Expect a valid SubBenchType but found " + filepath.Join(sub, subsub))
}

func (t SubBenchType) String() string {
	if t&GoKerBlocking != 0 {
		return filepath.Join("goker", "blocking")
	}
	if t&GoKerNonBlocking != 0 {
		return filepath.Join("goker", "nonblocking")
	}
	if t&GoRealBlocking != 0 {
		return filepath.Join("goreal", "blocking")
	}
	if t&GoRealNonBlocking != 0 {
		return filepath.Join("goreal", "nonblocking")
	}
	panic("No such type in sub-benchmarks")
}

type Bug struct {
	ID         string
	Type       SubBenchType
	SubType    string
	SubSubType string

	forkedPath string
	frozenPath string
	gobenchCfg string
}

func (b Bug) isBlocking() bool {
	return b.Type&GoKerBlocking|b.Type&GoRealBlocking != 0
}

func (b Bug) isNonBlocking() bool {
	return b.Type&GoKerNonBlocking|b.Type&GoRealNonBlocking != 0
}

func (b Bug) isGoKer() bool {
	return b.Type&GoKerBlocking|b.Type&GoKerNonBlocking != 0
}

func (b Bug) isGoReal() bool {
	return b.Type&GoRealBlocking|b.Type&GoRealNonBlocking != 0
}

func (b Bug) Fork() Bug {
	bug := b
	bug.fork("")
	return bug
}

func (b Bug) Dir() string {
	return b.forkedPath
}

func (b *Bug) fork(dir string) {
	if b.forkedPath != "" {
		copyAbsolutely(b.frozenPath, b.forkedPath)
		return
	}

	if dir == "" {
		dir = TestPath
	}

	if dir == BackupPath {
		panic("Backup path is not permitted to be the fork path.")
	}

	project, id := SplitBugID(b.ID)
	b.forkedPath = filepath.Join(dir, b.Type.String(), project, id)
	copyAbsolutely(b.frozenPath, b.forkedPath)
}

func isNumberOnly(bugid string) bool {
	if _, err := strconv.Atoi(bugid); err != nil {
		return false
	}
	return true
}

func SplitBugID(bugid string) (string, string) {
	if isNumberOnly(bugid) {
		return "", bugid
	}

	if strings.Contains(bugid, "_") {
		splits := strings.Split(bugid, "_")
		if len(splits) != 2 {
			panic("Invalid bugid: " + bugid)
		}
		return splits[0], splits[1]
	}

	bytes := []byte(bugid)
	for i := 0; i < len(bytes); i++ {
		suffix := bytes[i:]
		if isNumberOnly(string(suffix)) {
			return string(bytes[:i]), string(bytes[i:])
		}
	}

	panic("Can't split bugid: " + bugid)
}

func BugID(path string) string {
	if IsFile(path) {
		splits := strings.Split(path, string(os.PathSeparator))
		return strings.Join(splits[len(splits)-3:len(splits)-1], "_")
	}

	if IsDir(path) {
		splits := strings.Split(path, string(os.PathSeparator))
		return strings.Join(splits[len(splits)-2:len(splits)], "_")
	}

	project, id := SplitBugID(path)
	return project + "_" + id
}

func copyAbsolutely(src string, dst string) {
	/* rsync can handle this situation so we do not
	   need build images every time.
	if err := os.RemoveAll(dst); err != nil {
		pwd, _ := os.Getwd()
		log.Println("Curdir = ", pwd)
		log.Fatal(err)
	}
	*/
	options := grsync.RsyncOptions{Recursive: true}
	if IsFile(src) {
		options = grsync.RsyncOptions{}
	}
	task := grsync.NewTask(src, filepath.Dir(dst), options)
	if err := task.Run(); err != nil {
		log.Printf("Move %v to %v\n", src, filepath.Dir(dst))
		task.Log()
		panic(err)
	}
}
