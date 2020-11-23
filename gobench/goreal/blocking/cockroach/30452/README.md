
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#30452]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[cockroach#30452]:(cockroach30452_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/30452/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/30452
 
## Description

Some description from developers or pervious reseachers

> setReplicaID refreshes the proposal and was thus synchronously writing
  to the commandProposed chan. This channel could have filled up due to
  an earlier reproposal already, deadlocking the test.


## Backtrace

```
goroutine 1853272 [semacquire, 6 minutes]:
sync.runtime_SemacquireMutex(0xc00001b5f4, 0x0, 0x0)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*RWMutex).RLock(...)
	/usr/local/go/src/sync/rwmutex.go:50
github.com/cockroachdb/cockroach/pkg/storage.(*Replica).Desc(0xc00001b500, 0x0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/replica.go:1598 +0xc3
github.com/cockroachdb/cockroach/pkg/storage.(*Replica).startKey(...)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/replica.go:6738
github.com/cockroachdb/cockroach/pkg/storage.(*Replica).Less(0xc00001b500, 0x2b04040, 0xc004026980, 0x2)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/replica.go:6743 +0x2f
github.com/cockroachdb/cockroach/vendor/github.com/google/btree.(*node).iterate(0xc003d5bc40, 0xffffffffffffffff, 0x2b04040, 0xc004026980, 0x0, 0x0, 0xc0013b0001, 0xc0013bdb38, 0xc0013bdb10)
	/go/src/github.com/cockroachdb/cockroach/vendor/github.com/google/btree/btree.go:534 +0x305
github.com/cockroachdb/cockroach/vendor/github.com/google/btree.(*BTree).DescendLessOrEqual(...)
	/go/src/github.com/cockroachdb/cockroach/vendor/github.com/google/btree/btree.go:786
github.com/cockroachdb/cockroach/pkg/storage.(*Store).LookupReplica(0xc0038d8680, 0xc0000559e0, 0xb, 0xb, 0x0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/store.go:2144 +0x2ea
github.com/cockroachdb/cockroach/pkg/storage.(*Store).startGossip.func4(0x2b55fa0, 0xc003d4b140)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/store.go:1663 +0xf5
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc0002e82f0, 0xc003574870, 0xc003852dc0)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:199 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:192 +0xa8

goroutine 1853244 [sync.Cond.Wait, 6 minutes]:
runtime.goparkunlock(...)
	/usr/local/go/src/runtime/proc.go:310
sync.runtime_notifyListWait(0xc003d5b950, 0x20)
	/usr/local/go/src/runtime/sema.go:510 +0xf8
sync.(*Cond).Wait(0xc003d5b940)
	/usr/local/go/src/sync/cond.go:56 +0x9d
github.com/cockroachdb/cockroach/pkg/storage.(*raftScheduler).worker(0xc002de5880, 0x2b55fa0, 0xc003ec10e0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/scheduler.go:196 +0xaa
github.com/cockroachdb/cockroach/pkg/storage.(*raftScheduler).Start.func2(0x2b55fa0, 0xc003ec10e0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/scheduler.go:165 +0x3e
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc00038be60, 0xc003574870, 0xc00038be40)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:199 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:192 +0xa8

goroutine 1853274 [semacquire, 6 minutes]:
sync.runtime_SemacquireMutex(0xc00001b5ec, 0x687501, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc00001b5e8)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
	/usr/local/go/src/sync/mutex.go:81
sync.(*RWMutex).Lock(0xc00001b5e8)
	/usr/local/go/src/sync/rwmutex.go:98 +0x97
github.com/cockroachdb/cockroach/pkg/storage.(*Replica).redirectOnOrAcquireLease.func1(0xc00001b500, 0x162d17cf0ab09492, 0xc000000000, 0xc004102070, 0x2b55fa0, 0xc004152ea0, 0xc000308dd8, 0x0, 0x0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/replica.go:1379 +0x6c
github.com/cockroachdb/cockroach/pkg/storage.(*Replica).redirectOnOrAcquireLease(0xc00001b500, 0x2b55fa0, 0xc004152ea0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/replica.go:1497 +0x176
github.com/cockroachdb/cockroach/pkg/storage.(*Store).startLeaseRenewer.func1.1(0x1, 0xc00001b500, 0xc0004464d0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/store.go:1715 +0x95
github.com/cockroachdb/cockroach/pkg/util/syncutil.(*IntMap).Range(0xc0038d8a00, 0xc001285dd0)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/syncutil/int_map.go:338 +0x1c9
github.com/cockroachdb/cockroach/pkg/storage.(*Store).startLeaseRenewer.func1(0x2b55fa0, 0xc003d4b0b0)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/store.go:1712 +0x1b4
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc0002e8350, 0xc003574870, 0xc0002e8330)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:199 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:192 +0xa8

```

