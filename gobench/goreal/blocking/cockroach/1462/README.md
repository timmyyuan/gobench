
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#1462]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & WaitGroup |

[cockroach#1462]:(cockroach1462_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/1462/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/1462
 
## Description

See its [bug kernel](../../../../goker/blocking/cockroach/1462/README.md)


## Backtrace

```
goroutine 17 [syscall, locked to thread]:
runtime.goexit()
	/usr/local/go/src/runtime/asm_amd64.s:2197 +0x1

goroutine 5 [chan receive]:
github.com/cockroachdb/cockroach/util/log.(*loggingT).flushDaemon(0xabb980)
	/go/src/github.com/cockroachdb/cockroach/util/log/clog.go:1034 +0x77
created by github.com/cockroachdb/cockroach/util/log.init.1
	/go/src/github.com/cockroachdb/cockroach/util/log/clog.go:604 +0xeb

goroutine 7 [semacquire]:
sync.runtime_Semacquire(0xc42027055c)
	/usr/local/go/src/runtime/sema.go:47 +0x34
sync.(*WaitGroup).Wait(0xc420270550)
	/usr/local/go/src/sync/waitgroup.go:131 +0x7a
github.com/cockroachdb/cockroach/util.(*Stopper).Stop(0xc420270540)
	/go/src/github.com/cockroachdb/cockroach/util/stopper.go:132 +0x54
github.com/cockroachdb/cockroach/multiraft.validateHeartbeatSingleGroup(0x3, 0x0, 0xc42015e000)
	/go/src/github.com/cockroachdb/cockroach/multiraft/heartbeat_test.go:232 +0x568
github.com/cockroachdb/cockroach/multiraft.TestHeartbeatSingleGroup(0xc42015e000)
	/go/src/github.com/cockroachdb/cockroach/multiraft/heartbeat_test.go:147 +0x100
testing.tRunner(0xc42015e000, 0x8ba978)
	/usr/local/go/src/testing/testing.go:657 +0x96
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:697 +0x2ca

goroutine 93 [chan send]:
github.com/cockroachdb/cockroach/multiraft.(*localInterceptableTransport).start.func1()
	/go/src/github.com/cockroachdb/cockroach/multiraft/transport_test.go:64 +0x199
github.com/cockroachdb/cockroach/util.(*Stopper).RunWorker.func1(0xc420270540, 0xc42020c9d0)
	/go/src/github.com/cockroachdb/cockroach/util/stopper.go:75 +0x4d
created by github.com/cockroachdb/cockroach/util.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/util/stopper.go:76 +0x57
```

