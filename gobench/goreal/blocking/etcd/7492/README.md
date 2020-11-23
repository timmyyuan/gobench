
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[etcd#7492]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[etcd#7492]:(etcd7492_test.go)
[patch]:https://github.com/etcd-io/etcd/pull/7492/files
[pull request]:https://github.com/etcd-io/etcd/pull/7492
 
## Description

Some description from developers or pervious reseachers

> There's a deadlock in simpleTokenTTLKeeper. assignSimpleTokenToUser 
> acquires as.simpleTokensMu and posts to addSimpleTokenCh (suppose that 
> the channel is full so it blocks). If the goroutine simpleTokenTTLKeeper.run 
> happens to hit <-tokenTicker.C it will try to acquire simpleTokensMu while 
> calling deleteTokenFunc. Since only run can drain addSimpleTokenCh, the lock 
> is never released.

go-deadlock report a false positive because the inconsistent locking
already guarded by other synchronization operations that dominate it.

```
POTENTIAL DEADLOCK: Inconsistent locking. saw this ordering in one goroutine:
happened before
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:344 backend.(*backend).begin { b.mu.RLock() } <<<<<
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:198 backend.(*batchTx).commit { t.tx = t.backend.begin(true) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:255 backend.(*batchTxBuffered).commit { t.batchTx.commit(stop) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:234 backend.(*batchTxBuffered).Commit { t.commit(false) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:215 backend.newBatchTxBuffered { tx.Commit() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:128 backend.newBackend { b.batchTx = newBatchTxBuffered(b) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:361 backend.NewTmpBackend { return newBackend(tmpPath, batchInterval, batchLimit), tmpPath }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:365 backend.NewDefaultTmpBackend { return NewTmpBackend(defaultBatchInterval, defaultBatchLimit) }
store_test.go:76 auth.setupAuthStore { b, tPath := backend.NewDefaultTmpBackend() }
store_test.go:600 auth.TestHammerSimpleAuthenticate { as, tearDown := setupAuthStore(t) }

happened after
../gopath/src/github.com/boltdb/bolt/db.go:514 bolt.(*DB).beginRWTx { db.rwlock.Lock() } <<<<<
../gopath/src/github.com/boltdb/bolt/db.go:463 bolt.(*DB).Begin { return db.beginRWTx() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:345 backend.(*backend).begin { tx, err := b.db.Begin(write) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:198 backend.(*batchTx).commit { t.tx = t.backend.begin(true) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:255 backend.(*batchTxBuffered).commit { t.batchTx.commit(stop) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:234 backend.(*batchTxBuffered).Commit { t.commit(false) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:215 backend.newBatchTxBuffered { tx.Commit() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:128 backend.newBackend { b.batchTx = newBatchTxBuffered(b) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:361 backend.NewTmpBackend { return newBackend(tmpPath, batchInterval, batchLimit), tmpPath }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:365 backend.NewDefaultTmpBackend { return NewTmpBackend(defaultBatchInterval, defaultBatchLimit) }
store_test.go:76 auth.setupAuthStore { b, tPath := backend.NewDefaultTmpBackend() }
store_test.go:600 auth.TestHammerSimpleAuthenticate { as, tearDown := setupAuthStore(t) }

in another goroutine: happened before
../gopath/src/github.com/boltdb/bolt/db.go:514 bolt.(*DB).beginRWTx { db.rwlock.Lock() } <<<<<
../gopath/src/github.com/boltdb/bolt/db.go:463 bolt.(*DB).Begin { return db.beginRWTx() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:345 backend.(*backend).begin { tx, err := b.db.Begin(write) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:198 backend.(*batchTx).commit { t.tx = t.backend.begin(true) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:255 backend.(*batchTxBuffered).commit { t.batchTx.commit(stop) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:234 backend.(*batchTxBuffered).Commit { t.commit(false) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:215 backend.newBatchTxBuffered { tx.Commit() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:128 backend.newBackend { b.batchTx = newBatchTxBuffered(b) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:361 backend.NewTmpBackend { return newBackend(tmpPath, batchInterval, batchLimit), tmpPath }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:365 backend.NewDefaultTmpBackend { return NewTmpBackend(defaultBatchInterval, defaultBatchLimit) }
store_test.go:76 auth.setupAuthStore { b, tPath := backend.NewDefaultTmpBackend() }
store_test.go:600 auth.TestHammerSimpleAuthenticate { as, tearDown := setupAuthStore(t) }

happened after
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:344 backend.(*backend).begin { b.mu.RLock() } <<<<<
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:258 backend.(*batchTxBuffered).commit { t.backend.readTx.tx = t.backend.begin(false) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:234 backend.(*batchTxBuffered).Commit { t.commit(false) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:215 backend.newBatchTxBuffered { tx.Commit() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:128 backend.newBackend { b.batchTx = newBatchTxBuffered(b) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:361 backend.NewTmpBackend { return newBackend(tmpPath, batchInterval, batchLimit), tmpPath }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:365 backend.NewDefaultTmpBackend { return NewTmpBackend(defaultBatchInterval, defaultBatchLimit) }
store_test.go:76 auth.setupAuthStore { b, tPath := backend.NewDefaultTmpBackend() }
store_test.go:600 auth.TestHammerSimpleAuthenticate { as, tearDown := setupAuthStore(t) }
```

## Backtrace

```
goroutine 186978 [semacquire, 9 minutes]:
sync.runtime_SemacquireMutex(0xc000451234, 0x203000, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc000451230)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(0xc000451230)
	/usr/local/go/src/sync/mutex.go:81 +0x47
_/go/src/github.com/coreos/etcd/auth.(*authStore).Authenticate(0xc0004bc320, 0x7f2db4179040, 0xc00016c510, 0xc00009efc0, 0x7, 0xa034bc, 0x3, 0x0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/auth/store.go:261 +0x9c
_/go/src/github.com/coreos/etcd/auth.TestHammerSimpleAuthenticate.func2(0xc000473750, 0xc00009f918, 0xc0004bc320, 0xc00032e500, 0xc00009efc0, 0x7)
	/go/src/github.com/coreos/etcd/auth/store_test.go:622 +0x32d
created by _/go/src/github.com/coreos/etcd/auth.TestHammerSimpleAuthenticate
	/go/src/github.com/coreos/etcd/auth/store_test.go:618 +0x373

goroutine 187005 [semacquire, 9 minutes]:
sync.runtime_SemacquireMutex(0xc000451234, 0x203000, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc000451230)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(0xc000451230)
	/usr/local/go/src/sync/mutex.go:81 +0x47
_/go/src/github.com/coreos/etcd/auth.(*authStore).Authenticate(0xc0004bc320, 0x7f2db4179040, 0xc000305920, 0xc00009f5d8, 0x7, 0xa034bc, 0x3, 0x0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/auth/store.go:261 +0x9c
_/go/src/github.com/coreos/etcd/auth.TestHammerSimpleAuthenticate.func2(0xc000473750, 0xc00009f918, 0xc0004bc320, 0xc00032e500, 0xc00009f5d8, 0x7)
	/go/src/github.com/coreos/etcd/auth/store_test.go:622 +0x32d
created by _/go/src/github.com/coreos/etcd/auth.TestHammerSimpleAuthenticate
	/go/src/github.com/coreos/etcd/auth/store_test.go:618 +0x373

goroutine 186317 [semacquire, 9 minutes]:
sync.runtime_SemacquireMutex(0xc000451234, 0xc000039e00, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc000451230)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
	/usr/local/go/src/sync/mutex.go:81
github.com/coreos/etcd/mvcc/backend.(*batchTxBuffered).Commit(0xc000451230)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:232 +0x9f
github.com/coreos/etcd/mvcc/backend.(*backend).run(0xc0003318c0)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:211 +0xdb
created by github.com/coreos/etcd/mvcc/backend.newBackend
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:129 +0x19d

goroutine 186994 [semacquire, 9 minutes]:
sync.runtime_SemacquireMutex(0xc000451234, 0x203000, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc000451230)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(0xc000451230)
	/usr/local/go/src/sync/mutex.go:81 +0x47
_/go/src/github.com/coreos/etcd/auth.(*authStore).Authenticate(0xc0004bc320, 0x7f2db4179040, 0xc0003059e0, 0xc00009e5b8, 0x7, 0xa034bc, 0x3, 0x0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/auth/store.go:261 +0x9c
_/go/src/github.com/coreos/etcd/auth.TestHammerSimpleAuthenticate.func2(0xc000473750, 0xc00009f918, 0xc0004bc320, 0xc00032e500, 0xc00009e5b8, 0x7)
	/go/src/github.com/coreos/etcd/auth/store_test.go:622 +0x32d
created by _/go/src/github.com/coreos/etcd/auth.TestHammerSimpleAuthenticate
	/go/src/github.com/coreos/etcd/auth/store_test.go:618 +0x373

...
```

