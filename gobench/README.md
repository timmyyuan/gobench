# GoBnech

GoBench consists of two parts, namely GoReal and GoKer. The `./configures`
directory is composed of files in json format. These files record the type
of each bug in GoBench. For bugs in GoReal, it also records how to generate
their corresponding Dockerfile. The files in configures can be used for 
researchers and deverlopers to add new bugs.

In the two directories `./goreal` and `./goker`, the data sets of GoKer and
GoReal are contained respectively. Under the two directories, each bug is 
placed in its own directory, which is named like `./<project>/<pull id>`.
Each bug owned directory contains a README.md file to describe the basic
information and description of the bug.

In the upper-level directory of this directory, it is also recorded how
to call the interface we have defined in Go to reproduce a bug. We also
recommend calling gobench as a Go module instead of manual reproduction 
as we mentioned below.

## GoReal

For each bug in GoReal, the bug owned directory tree is
```
./goreal/<project>/<pull id>/
    - bug.Dockerfile
    - fix.Dockerfile
    - bug_patch.diff
    - README.md
```

`bug.Dockerfile` contains all dependencies to reproduce this bug. In most
cases, users can build a image from `bug.Dockerfile` through docker: 
```

```
and then directly run
```sh
docker run <image name> /go/gobench.test -test.v -test.count 1 -test.run <test function>
```
to reproduce the bug. Here the test function can be found in the
corresponding bug ID in the configuration file we mentioned above.

`fix.Dockerfile` is the fixed version of the bug.

`bug_patch.diff` contains the patch to convert sources from the fixed 
version to the buggy version. Users should not modify this file. To add
new bug to GoBench. The patch file should also be upload to GoBench 
manually by the committer.

For GoReal, users can customize the Dockerfile and submit the corresponding
bug_patch.diff. But in our experience, using the configure file can manage
bugs in GoReal more conveniently.

## GoKer

For each bug in GoKer, the bug owned directory tree is
```
./goker/<project>/<pull id>
    - <project><pull id>_test.go
    - README.md
``` 

`<project><pull id>_test.go` is a standard Go test file. Users can run
```
go test -v -count 1 <project><pull id>_test.go
``` 
to reproduce a bug in the Go test file.
