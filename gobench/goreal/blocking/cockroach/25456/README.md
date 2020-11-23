
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#25456]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[cockroach#25456]:(cockroach25456_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/25456/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/25456
 
## Description

Some description from developers or pervious reseachers

> When CheckConsistency returns an error, the queue checks whether the
  store is draining to decide whether the error is worth logging.
  Unfortunately this check was incorrect and would block until the store
  actually started draining.

See its [bug kernel](../../../../goker/blocking/cockroach/25456)

## Backtrace

```
goroutine 8 [chan receive, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/storage.(*consistencyQueue).process(0xc0002d08a0, 0x274c2a0, 0xc0000c8020, 0xc0001d1500, 0x0, 0x0, 0x0, 0x0, 0x0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/consistency_queue.go:107 +0x122
github.com/cockroachdb/cockroach/pkg/storage.TestConsistenctQueueErrorFromCheckConsistency(0xc000232100)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/replica_test.go:9294 +0x27f
testing.tRunner(0xc000232100, 0x2390250)
	/usr/local/go/src/testing/testing.go:909 +0xc9
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x350

goroutine 9 [chan receive, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/rpc.NewContext.func1(0x274c320, 0xc0000b2810)
	/go/src/github.com/cockroachdb/cockroach/pkg/rpc/context.go:321 +0x51
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc0000b1e80, 0xc00003c3f0, 0xc0002d0220)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:193 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:186 +0xa8

goroutine 10 [sync.Cond.Wait]:
runtime.goparkunlock(...)
	/usr/local/go/src/runtime/proc.go:310
sync.runtime_notifyListWait(0xc000138c88, 0xd)
	/usr/local/go/src/runtime/sema.go:510 +0xf8
sync.(*Cond).Wait(0xc000138c78)
	/usr/local/go/src/sync/cond.go:56 +0x9d
github.com/cockroachdb/cockroach/pkg/storage/engine.(*RocksDB).syncLoop(0xc000138b60)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/engine/rocksdb.go:637 +0xa6
created by github.com/cockroachdb/cockroach/pkg/storage/engine.(*RocksDB).open
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/engine/rocksdb.go:624 +0x325

goroutine 11 [chan receive, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/storage.(*raftScheduler).Start.func1(0x274c320, 0xc0002b4030)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/scheduler.go:156 +0x49
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc000237620, 0xc00003c3f0, 0xc0002d0de0)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:193 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:186 +0xa8

goroutine 16 [sync.Cond.Wait, 7 minutes]:
runtime.goparkunlock(...)
	/usr/local/go/src/runtime/proc.go:310
sync.runtime_notifyListWait(0xc0000f0010, 0x25)
	/usr/local/go/src/runtime/sema.go:510 +0xf8
sync.(*Cond).Wait(0xc0000f0000)
	/usr/local/go/src/sync/cond.go:56 +0x9d
github.com/cockroachdb/cockroach/pkg/storage.(*raftScheduler).worker(0xc00003c480, 0x274c320, 0xc0002b4c00)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/scheduler.go:197 +0x9d
github.com/cockroachdb/cockroach/pkg/storage.(*raftScheduler).Start.func2(0x274c320, 0xc0002b4c00)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/scheduler.go:166 +0x3e
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc000237890, 0xc00003c3f0, 0xc000237880)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:193 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:186 +0xa8
```

