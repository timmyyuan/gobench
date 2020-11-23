package gobench

import (
	"bytes"
	"go/ast"
	"go/parser"
	"go/printer"
	"go/token"
	"golang.org/x/tools/go/ast/astutil"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func InstrumentGoleak(file string) {
	fset := token.NewFileSet()
	astF, err := parser.ParseFile(fset, file, nil, 0)
	if err != nil {
		panic(err)
	}

	var entryFunc *ast.FuncDecl
	astutil.Apply(astF, func(cur *astutil.Cursor) bool {
		if node, ok := cur.Node().(*ast.FuncDecl); ok {
			if strings.HasPrefix(node.Name.Name, "Test") {
				entryFunc = node
				return false
			}
		}
		return true
	}, nil)

	entryFunc.Body.List = append([]ast.Stmt{&ast.DeferStmt{
		Call: &ast.CallExpr{
			Fun: &ast.SelectorExpr{
				X:   &ast.Ident{Name: "goleak"},
				Sel: &ast.Ident{Name: "VerifyNone"},
			},
			Args: []ast.Expr{
				&ast.BasicLit{Value: "t"},
			},
		}}}, entryFunc.Body.List...)

	var buf bytes.Buffer
	astutil.AddImport(fset, astF, "go.uber.org/goleak")
	printer.Fprint(&buf, fset, astF)
	ioutil.WriteFile(file, buf.Bytes(), 0644)
}

func InstrumentGoDeadlock(file string) {
	commands := [][]string{
		[]string{"sed", "-i", "s/sync.RWMutex/deadlock.RWMutex/", file},
		[]string{"sed", "-i", "s/sync.Mutex/deadlock.Mutex/", file},
	}
	for _, args := range commands {
		if out, err := exec.Command(args[0], args[1:]...).CombinedOutput(); err != nil {
			log.Println(string(out))
			panic(err)
		}
	}

	abspath, _ := filepath.Abs(file)
	cmd := exec.Command("goimports", "-w", abspath)
	cmd.Dir = os.Getenv("HOME")
	if out, err := cmd.CombinedOutput(); err != nil {
		log.Println(string(out))
		panic(err)
	}
}

func InstrumentMainFunc(file string) {
	commands := [][]string{
		[]string{"sed", "-i", "s/^func Test.*/func main() {\\n/", file},
		[]string{"sed", "-i", "s/^package.*/package main\\n/", file},
		[]string{"sed", "-i", "/*\"testing\"*/d", file},
	}
	for _, args := range commands {
		if out, err := exec.Command(args[0], args[1:]...).CombinedOutput(); err != nil {
			log.Println(string(out))
			panic(err)
		}
	}

	abspath, _ := filepath.Abs(file)
	cmd := exec.Command("goimports", "-w", abspath)
	cmd.Dir = os.Getenv("HOME")
	if out, err := cmd.CombinedOutput(); err != nil {
		log.Println(string(out))
		panic(err)
	}
}
