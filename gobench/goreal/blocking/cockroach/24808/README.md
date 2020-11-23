
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#24808]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[cockroach#24808]:(cockroach24808_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/24808/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/24808
 
## Description

Some description from developers or pervious reseachers

> When we Start the Compactor, it may already have received
  Suggestions, deadlocking the previously blocking write to a full
  channel.

See its [bug kernel](../../../../goker/blocking/cockroach/24808/README.md)

## Backtrace

```
goroutine 7 [syscall, 10 minutes]:
os/signal.signal_recv(0x0)
	/usr/local/go/src/runtime/sigqueue.go:147 +0x9c
os/signal.loop()
	/usr/local/go/src/os/signal/signal_unix.go:23 +0x22
created by os/signal.init.0
	/usr/local/go/src/os/signal/signal_unix.go:29 +0x41

goroutine 8 [chan receive]:
github.com/cockroachdb/cockroach/pkg/util/log.flushDaemon()
	/go/src/github.com/cockroachdb/cockroach/pkg/util/log/clog.go:1128 +0xf2
created by github.com/cockroachdb/cockroach/pkg/util/log.init.0
	/go/src/github.com/cockroachdb/cockroach/pkg/util/log/clog.go:591 +0x10b

goroutine 9 [chan receive, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/util/log.signalFlusher()
	/go/src/github.com/cockroachdb/cockroach/pkg/util/log/clog.go:598 +0x124
created by github.com/cockroachdb/cockroach/pkg/util/log.init.0
	/go/src/github.com/cockroachdb/cockroach/pkg/util/log/clog.go:592 +0x123

goroutine 12 [chan send, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/storage/compactor.(*Compactor).Start(0xc0004df800, 0x158d180, 0xc000038050, 0x15881c0, 0xc000218120, 0xc000142fc0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/compactor/compactor.go:132 +0x3d
github.com/cockroachdb/cockroach/pkg/storage/compactor.TestCompactorDeadlockOnStart(0xc00001e700)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/compactor/compactor_test.go:557 +0x1e8
testing.tRunner(0xc00001e700, 0x14597e8)
	/usr/local/go/src/testing/testing.go:909 +0xc9
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x350

goroutine 13 [sync.Cond.Wait, 10 minutes]:
runtime.goparkunlock(...)
	/usr/local/go/src/runtime/proc.go:310
sync.runtime_notifyListWait(0xc000111308, 0x0)
	/usr/local/go/src/runtime/sema.go:510 +0xf8
sync.(*Cond).Wait(0xc0001112f8)
	/usr/local/go/src/sync/cond.go:56 +0x9d
github.com/cockroachdb/cockroach/pkg/storage/engine.(*RocksDB).syncLoop(0xc0001111e0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/engine/rocksdb.go:636 +0xa6
created by github.com/cockroachdb/cockroach/pkg/storage/engine.(*RocksDB).open
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/engine/rocksdb.go:623 +0x325
```

