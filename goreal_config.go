package gobench

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"text/template"
	"time"
)

func GoRealConfigPath(bug Bug) string {
	cfgpath := filepath.Join(BackupPath, "configures")
	if bug.isBlocking() {
		cfgpath = filepath.Join(cfgpath, "goreal", "blocking.json")
	} else {
		cfgpath = filepath.Join(cfgpath, "goreal", "nonblocking.json")
	}
	return cfgpath
}

type GitDep struct {
	Url string `json:"url"`
	Dst string `json:"dst"`
}

func (d GitDep) String() string {
	return strings.Join([]string{"git", "clone", d.Url, d.Dst}, " ")
}

type PkgDep string

func (d PkgDep) String() string {
	return strings.Join([]string{"go", "get", "-v", "-d", string(d)}, " ")
}

type GoRealBugConfig struct {
	bug Bug

	Type    string `json:"type"`
	SubType string `json:"subtype"`

	GoVersion string        `json:"goversion"`
	DevDeps   []string      `json:"dev_deps"`
	PkgDeps   []PkgDep      `json:"pkg_deps"`
	GitDeps   []GitDep      `json:"git_deps"`
	RepoUrl   string        `json:"repo_url"`
	SrcPath   string        `json:"src_path"`
	PullSHA   string        `json:"pull_sha"`
	TestEnvs  []string      `json:"testenvs"`
	TestFunc  string        `json:"testfunc"`
	WorkDir   string        `json:"workdir"`
	DefaultT  time.Duration `json:"default_timeout"`
	DefaultC  int           `json:"default_timeout"`

	PredStageCmd string `json:"pred_stage_build_command"`

	PredBuildCmds []string `json:"pred_commands"`
	BuildCmds     []string `json:"build_commands"`
	PostBuildCmds []string `json:"post_commands"`
}

func NewGoRealBugConfig(bug Bug, config string) *GoRealBugConfig {
	bugid := bug.ID

	if config == "" {
		config = bug.gobenchCfg
	}

	b, err := ioutil.ReadFile(config)
	if err != nil {
		panic(err)
	}

	var result map[string]*GoRealBugConfig
	if err := json.Unmarshal(b, &result); err != nil {
		panic(err)
	}

	result[bugid].bug = bug
	return result[bugid]
}

var DefaultTemp = `FROM golang:{{.GoVersion}}
# Clone the project to local
RUN git clone {{.RepoUrl}}.git /go/src/{{.SrcPath}}
{{if .HasDevDeps}}
# Update development envirnoment
RUN apt update && apt install -y {{join .DevDeps " "}}
{{- end}}
{{if .HasGoProxy}}
# Set GOPROXY if needed
RUN go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct
{{- end}}
{{if .HasHttpProxy}}
RUN git config --global http.proxy {{.HttpProxy}} && \
	git config --global https.proxy {{.HttpProxy}}
ENV HTTP_PROXY {{.HttpProxy}}
ENV HTTPS_PROXY {{.HttpProxy}}
{{- end}}
{{if .HasPkgDeps}}
# Download needed packages
RUN {{depjoin .PkgDeps}}
{{- end}}
WORKDIR /go/src/{{.SrcPath}}
{{if .HasGitDeps}}
# Download git submodules
RUN {{depjoin .GitDeps}}
{{- end}}
# Rollback to the latest bug-free version
RUN git reset --hard {{.PullSHA}}

# Apply the revert patch to this bug
COPY ./bug_patch.diff {{.SrcPath}}/bug_patch.diff
RUN git apply {{.SrcPath}}/bug_patch.diff
{{if .HasPredCMD}}
# Pred-build
RUN {{.StrPredBuildCmds}}
{{- end}}
{{if .HasBuildCMD}}
# Build
RUN {{.StrBuildCmds}}
{{- end}}
{{if .HasPostCMD}}
# Post-build
RUN {{.StrPostBuildCmds}}
{{- end}}
# For entrypoint
WORKDIR /go/src/{{.SrcPath}}/{{.WorkDir}}
`

func (c *GoRealBugConfig) UpdateDockerfile() {
	type ConfigWarpper struct {
		*GoRealBugConfig
		HasDevDeps, HasGitDeps, HasPkgDeps  bool
		HasPredCMD, HasBuildCMD, HasPostCMD bool
		HasGoProxy, HasHttpProxy            bool
		HttpProxy                           string

		BugPath, StrPredBuildCmds, StrBuildCmds, StrPostBuildCmds string
	}

	genCMD := func(cmds []string) string {
		return strings.Join(cmds, " && \\\n    ")
	}

	depCMD := func(t interface{}) string {
		var result []string
		s := reflect.ValueOf(t)
		for i := 0; i < s.Len(); i++ {
			result = append(result, fmt.Sprintf("%v", s.Index(i)))
		}
		return genCMD(result)
	}

	needProxy := len(os.Getenv("NEED_PROXY")) > 0

	var warpper = ConfigWarpper{
		GoRealBugConfig:  c,
		HasDevDeps:       len(c.DevDeps) > 0,
		HasGitDeps:       len(c.GitDeps) > 0,
		HasPkgDeps:       len(c.PkgDeps) > 0,
		HasPredCMD:       len(c.PredBuildCmds) > 0,
		HasBuildCMD:      len(c.BuildCmds) > 0,
		HasPostCMD:       len(c.PostBuildCmds) > 0,
		HasGoProxy:       false,
		HasHttpProxy:     needProxy,
		HttpProxy:        os.Getenv("NEED_PROXY"),
		StrPredBuildCmds: genCMD(c.PredBuildCmds),
		StrBuildCmds:     genCMD(c.BuildCmds),
		StrPostBuildCmds: genCMD(c.PostBuildCmds),
	}

	var funcs = template.FuncMap{"join": strings.Join, "depjoin": depCMD}
	var t = template.Must(template.New("dockerfile").Funcs(funcs).Parse(DefaultTemp))

	var dockerfile string
	buf := bytes.NewBufferString(dockerfile)
	if err := t.Execute(buf, warpper); err != nil {
		panic(err)
	}

	if c.bug.forkedPath == "" {
		c.bug.fork(TestPath)
	}

	path := filepath.Join(c.bug.forkedPath, "bug.Dockerfile")
	// log.Println(path)
	if err := ioutil.WriteFile(path, buf.Bytes(), 0644); err != nil {
		panic(err)
	}
}
