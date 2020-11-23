package gobench

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"sync"
)

func IsFile(path string) bool {
	fi, err := os.Stat(path)
	if err != nil {
		return false
	}
	return fi.Mode().IsRegular()
}

func IsDir(path string) bool {
	fi, err := os.Stat(path)
	if err != nil {
		return false
	}
	return fi.Mode().IsDir()
}

func IsNotExists(path string) bool {
	if _, err := os.Stat(path); os.IsNotExist(err) {
		return true
	}
	return false
}

func WithTempFile(filename string, content string, fn func(name string)) {
	dir := filepath.Join(os.TempDir(), "gobench")
	if IsNotExists(dir) {
		if err := os.Mkdir(dir, 0700); err != nil {
			panic(err)
		}
	}

	tempfile, err := ioutil.TempFile(dir, filename)
	if err != nil {
		log.Fatal(err)
	}

	if len(content) > 0 {
		if _, err := tempfile.Write([]byte(content)); err != nil {
			log.Fatal(err)
		}
	}

	fn(tempfile.Name())

	if err := tempfile.Close(); err != nil {
		log.Fatal(err)
	}
}

func BatchJobsSlow(tasks []func(), jobs int) bool {
	for i := 0; i < len(tasks); i += jobs {
		var wg sync.WaitGroup
		for j := 0; j < jobs && i+j < len(tasks); j++ {
			wg.Add(1)
			go func(k int) {
				defer wg.Done()
				tasks[k]()
			}(i + j)
		}
		wg.Wait()
	}
	return true
}

func BatchJobs(tasks []func(), jobs int) bool {
	doneCh := make(chan struct{}, jobs)
	stopCh := make(chan struct{})
	cond := sync.NewCond(&sync.Mutex{})
	var wg sync.WaitGroup
	wg.Add(len(tasks) + 2)
	var numRunning int
	go func() {
		defer wg.Done()
		for {
			select {
			case <-doneCh:
				cond.L.Lock()
				numRunning -= 1
				cond.Signal()
				cond.L.Unlock()
			case <-stopCh:
				return
			}
		}
	}()

	go func() {
		defer wg.Done()
		defer close(stopCh)
		for i := 0; i < len(tasks); i++ {
			cond.L.Lock()
			for numRunning >= jobs {
				cond.Wait()
			}
			index := i
			numRunning += 1
			cond.L.Unlock()

			go func() {
				defer wg.Done()
				tasks[index]()
				doneCh <- struct{}{}
			}()
		}
	}()
	wg.Wait()
	return true
}

func Readlines(path string) []string {
	file, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var result []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		result = append(result, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	return result
}

func GoKer(bugid string) Bug {
	bugs := GoBenchBugSet.ListByTypes(GoKerBlocking | GoKerNonBlocking)

	for _, bug := range bugs {
		if bugid == bug.ID {
			return bug.Fork()
		}
	}
	panic(fmt.Errorf("Try to find %s with type GoKer but found nothing", bugid))
}

func GoReal(bugid string) Bug {
	bugs := GoBenchBugSet.ListByTypes(GoRealBlocking | GoRealNonBlocking)

	for _, bug := range bugs {
		if bugid == bug.ID {
			return bug.Fork()
		}
	}

	panic(fmt.Errorf("Try to find %s with type GoReal but found nothing", bugid))
}
