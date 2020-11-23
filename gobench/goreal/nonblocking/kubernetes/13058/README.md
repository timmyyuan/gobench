
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#13058]|[pull request]|[patch]| NonBlocking | Go-Specific | Special Libraries |

[kubernetes#13058]:(kubernetes13058_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/13058/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/13058
 
## Description

Built-in race detector can find a race below (there are many other similar reports), 
but this is not the bug descripted in [kubernetes#13058]. We did not regard the bug 
reported by the race detector as a false positive because the race actually exists 
in the program. Instead, we treat this bug as a false negative because the race
detector didn't find the real bug. 

```
Write at 0x00c000274b42 by goroutine 11:
  fmt.newPrinter()
      /usr/local/go/src/fmt/print.go:138 +0x6f
  fmt.Sprintf()
      /usr/local/go/src/fmt/print.go:218 +0x33
  testing.fmtDuration()
      /usr/local/go/src/testing/testing.go:538 +0xd5
  testing.(*T).report()
      /usr/local/go/src/testing/testing.go:1136 +0x83
  testing.tRunner.func1()
      /usr/local/go/src/testing/testing.go:873 +0x686
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:539 +0x3a
  _/go/src/k8s.io/kubernetes/pkg/controller/framework_test.TestUpdate()
      /go/src/k8s.io/kubernetes/pkg/controller/framework/controller_test.go:390 +0xb74
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Previous write at 0x00c000274b42 by goroutine 123:
  fmt.newPrinter()
      /usr/local/go/src/fmt/print.go:138 +0x6f
  fmt.Fprintf()
      /usr/local/go/src/fmt/print.go:203 +0x33
  github.com/golang/glog.(*loggingT).printf()
      /go/src/k8s.io/kubernetes/Godeps/_workspace/src/github.com/golang/glog/glog.go:651 +0xe8
  k8s.io/kubernetes/pkg/util.logPanic()
      /go/src/k8s.io/kubernetes/Godeps/_workspace/src/github.com/golang/glog/glog.go:1118 +0x227
  k8s.io/kubernetes/pkg/util.HandleCrash()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/util/util.go:54 +0xda
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:539 +0x3a
  _/go/src/k8s.io/kubernetes/pkg/controller/framework_test.TestUpdate.func2()
      /usr/local/go/src/sync/waitgroup.go:99 +0x4b
  k8s.io/kubernetes/pkg/controller/framework.(*ResourceEventHandlerFuncs).OnDelete()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:182 +0x8d
  k8s.io/kubernetes/pkg/controller/framework.NewInformer.func1()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:252 +0x413
  k8s.io/kubernetes/pkg/controller/framework.(*Controller).processLoop()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:126 +0x9b
  k8s.io/kubernetes/pkg/controller/framework.(*Controller).processLoop-fm()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:123 +0x41
  k8s.io/kubernetes/pkg/util.Until.func1()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/util/util.go:115 +0x6f
  k8s.io/kubernetes/pkg/util.Until()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/util/util.go:116 +0x3a
  k8s.io/kubernetes/pkg/controller/framework.(*Controller).Run()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:96 +0x28d

Goroutine 11 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:960 +0x651
  testing.runTests.func1()
      /usr/local/go/src/testing/testing.go:1202 +0xa6
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
  testing.runTests()
      /usr/local/go/src/testing/testing.go:1200 +0x521
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:1117 +0x2ff
  main.main()
      _testmain.go:54 +0x223

Goroutine 123 (running) created at:
  _/go/src/k8s.io/kubernetes/pkg/controller/framework_test.TestUpdate()
      /go/src/k8s.io/kubernetes/pkg/controller/framework/controller_test.go:340 +0x6e9
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

## Backtrace

```
panic: sync: WaitGroup is reused before previous Wait has returned [recovered]
	panic: sync: WaitGroup is reused before previous Wait has returned

goroutine 214 [running]:
testing.tRunner.func1(0xc00024eb00)
	/usr/local/go/src/testing/testing.go:874 +0x69f
panic(0xbb56c0, 0xd6fd50)
	/usr/local/go/src/runtime/panic.go:679 +0x1b2
sync.(*WaitGroup).Wait(0xc00042c430)
	/usr/local/go/src/sync/waitgroup.go:132 +0x142
_/go/src/k8s.io/kubernetes/pkg/controller/framework_test.TestUpdate(0xc00024eb00)
	/go/src/k8s.io/kubernetes/pkg/controller/framework/controller_test.go:390 +0xb75
testing.tRunner(0xc00024eb00, 0xcc5dc0)
	/usr/local/go/src/testing/testing.go:909 +0x19a
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x652
```

