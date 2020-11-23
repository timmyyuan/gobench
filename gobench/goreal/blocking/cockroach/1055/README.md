
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#1055]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & WaitGroup |

[cockroach#1055]:(cockroach1055_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/1055/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/1055
 
## Description

See its [bug kernel](../../../../goker/blocking/cockroach/1055/README.md)

## Backtrace

```
panic: timed out waiting for stop [recovered]
	panic: timed out waiting for stop

goroutine 21 [running]:
panic(0x792640, 0xc8200fc000)
	/usr/local/go/src/runtime/panic.go:481 +0x3e6
testing.tRunner.func1(0xc820098120)
	/usr/local/go/src/testing/testing.go:467 +0x192
panic(0x792640, 0xc8200fc000)
	/usr/local/go/src/runtime/panic.go:443 +0x4e9
github.com/cockroachdb/cockroach/util.TestStopperQuiesce(0xc820098120)
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:223 +0x54d
testing.tRunner(0xc820098120, 0xaea1b8)
	/usr/local/go/src/testing/testing.go:473 +0x98
created by testing.RunTests
	/usr/local/go/src/testing/testing.go:582 +0x892

goroutine 1 [chan receive]:
testing.RunTests(0x981428, 0xae9fc0, 0x21, 0x21, 0x8be001)
	/usr/local/go/src/testing/testing.go:583 +0x8d2
testing.(*M).Run(0xc820047ef8, 0x7fbd63f8e968)
	/usr/local/go/src/testing/testing.go:515 +0x81
main.main()
	github.com/cockroachdb/cockroach/util/_test/_testmain.go:122 +0x117

goroutine 17 [syscall, locked to thread]:
runtime.goexit()
	/usr/local/go/src/runtime/asm_amd64.s:1998 +0x1

goroutine 20 [chan receive]:
github.com/cockroachdb/cockroach/util/log.(*loggingT).flushDaemon(0xaecfc0)
	/go/src/github.com/cockroachdb/cockroach/util/log/clog.go:930 +0x67
created by github.com/cockroachdb/cockroach/util/log.init.1
	/go/src/github.com/cockroachdb/cockroach/util/log/clog.go:360 +0xbc

goroutine 22 [chan receive]:
github.com/cockroachdb/cockroach/util.TestStopperQuiesce.func1(0xc82006a780, 0xc82006a4e0, 0xc820098120, 0xc82006a7e0)
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:193 +0x16e
created by github.com/cockroachdb/cockroach/util.TestStopperQuiesce
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:195 +0x324

goroutine 23 [chan receive]:
github.com/cockroachdb/cockroach/util.TestStopperQuiesce.func1(0xc82006a840, 0xc82006a600, 0xc820098120, 0xc82006a8a0)
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:193 +0x16e
created by github.com/cockroachdb/cockroach/util.TestStopperQuiesce
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:195 +0x324

goroutine 24 [chan receive]:
github.com/cockroachdb/cockroach/util.TestStopperQuiesce.func1(0xc82006a900, 0xc82006a720, 0xc820098120, 0xc82006a960)
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:193 +0x16e
created by github.com/cockroachdb/cockroach/util.TestStopperQuiesce
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:195 +0x324

goroutine 25 [semacquire]:
sync.runtime_Semacquire(0xc82006a518)
	/usr/local/go/src/runtime/sema.go:47 +0x26
sync.(*WaitGroup).Wait(0xc82006a50c)
	/usr/local/go/src/sync/waitgroup.go:127 +0xb4
github.com/cockroachdb/cockroach/util.(*Stopper).Stop(0xc82006a4e0)
	/go/src/github.com/cockroachdb/cockroach/util/stopper.go:127 +0xb6
github.com/cockroachdb/cockroach/util.TestStopperQuiesce.func2(0xc8200d87c0, 0x3, 0x4, 0xc8200d87e0, 0x3, 0x4, 0xc8200d8800, 0x3, 0x4, 0xc82006a9c0)
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:214 +0x1b5
created by github.com/cockroachdb/cockroach/util.TestStopperQuiesce
	/go/src/github.com/cockroachdb/cockroach/util/stopper_test.go:217 +0x3f2
```

