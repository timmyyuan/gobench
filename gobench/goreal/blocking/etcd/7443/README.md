
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[etcd#7443]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[etcd#7443]:(etcd7443_test.go)
[patch]:https://github.com/etcd-io/etcd/pull/7443/files
[pull request]:https://github.com/etcd-io/etcd/pull/7443
 
## Description

Some description from developers or pervious reseachers

> lbWatcher listens on b.notifyCh via balancer.Notify() and it 
> is blocked on tearDown(). balancer.Up() acquires lock and is 
> blocked sending addrs to b.notifyCh.

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
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:104 backend.NewDefaultBackend { return newBackend(path, defaultBatchInterval, defaultBatchLimit) }
../gopath/src/github.com/coreos/etcd/etcdserver/server.go:273 etcdserver.NewServer.func1 { be = backend.NewDefaultBackend(bepath) }

happened after
../gopath/src/github.com/boltdb/bolt/db.go:514 bolt.(*DB).beginRWTx { db.rwlock.Lock() } <<<<<
../gopath/src/github.com/boltdb/bolt/db.go:463 bolt.(*DB).Begin { return db.beginRWTx() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:345 backend.(*backend).begin { tx, err := b.db.Begin(write) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:198 backend.(*batchTx).commit { t.tx = t.backend.begin(true) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:255 backend.(*batchTxBuffered).commit { t.batchTx.commit(stop) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:234 backend.(*batchTxBuffered).Commit { t.commit(false) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:215 backend.newBatchTxBuffered { tx.Commit() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:128 backend.newBackend { b.batchTx = newBatchTxBuffered(b) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:104 backend.NewDefaultBackend { return newBackend(path, defaultBatchInterval, defaultBatchLimit) }
../gopath/src/github.com/coreos/etcd/etcdserver/server.go:273 etcdserver.NewServer.func1 { be = backend.NewDefaultBackend(bepath) }

in another goroutine: happened before
../gopath/src/github.com/boltdb/bolt/db.go:514 bolt.(*DB).beginRWTx { db.rwlock.Lock() } <<<<<
../gopath/src/github.com/boltdb/bolt/db.go:463 bolt.(*DB).Begin { return db.beginRWTx() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:345 backend.(*backend).begin { tx, err := b.db.Begin(write) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:198 backend.(*batchTx).commit { t.tx = t.backend.begin(true) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:255 backend.(*batchTxBuffered).commit { t.batchTx.commit(stop) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:234 backend.(*batchTxBuffered).Commit { t.commit(false) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/batch_tx.go:215 backend.newBatchTxBuffered { tx.Commit() }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:128 backend.newBackend { b.batchTx = newBatchTxBuffered(b) }
../gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:104 backend.NewDefaultBackend { return newBackend(path, defaultBatchInterval, defaultBatchLimit) }
../gopath/src/github.com/coreos/etcd/etcdserver/server.go:273 etcdserver.NewServer.func1 { be = backend.NewDefaultBackend(bepath) }
```

## Backtrace

```
sync.runtime_Semacquire(0xc4240b59c4)
	/usr/lib/go-1.7/src/runtime/sema.go:47 +0x30
sync.(*Mutex).Lock(0xc4240b59c0)
	/usr/lib/go-1.7/src/sync/mutex.go:85 +0xde
google.golang.org/grpc.(*addrConn).tearDown(0xc4240b58c0, 0x15e6420, 0xc4200117e0)
	/home/jenkins/workspace/etcd-proxy/gopath/src/google.golang.org/grpc/clientconn.go:857 +0x91
google.golang.org/grpc.(*ClientConn).lbWatcher(0xc42215c360)
	/home/jenkins/workspace/etcd-proxy/gopath/src/google.golang.org/grpc/clientconn.go:420 +0x9dc
created by google.golang.org/grpc.DialContext
	/home/jenkins/workspace/etcd-proxy/gopath/src/google.golang.org/grpc/clientconn.go:339 +0x778

goroutine 70415 [chan send, 10 minutes]:
github.com/coreos/etcd/clientv3.(*simpleBalancer).Up(0xc4214f7900, 0xc425197ef7, 0x1e, 0x0, 0x0, 0x0)
  	/home/jenkins/workspace/etcd-proxy/gopath/src/github.com/coreos/etcd/clientv3/balancer.go:153 +0x389
google.golang.org/grpc.(*addrConn).resetTransport(0xc4240b58c0, 0xc4220c0500, 0xc422ada2c0, 0xc4220e23f0)
  	/home/jenkins/workspace/etcd-proxy/gopath/src/google.golang.org/grpc/clientconn.go:737 +0xe7b
google.golang.org/grpc.(*ClientConn).resetAddrConn.func1(0xc4240b58c0)
  	/home/jenkins/workspace/etcd-proxy/gopath/src/google.golang.org/grpc/clientconn.go:498 +0x42
created by google.golang.org/grpc.(*ClientConn).resetAddrConn
  	/home/jenkins/workspace/etcd-proxy/gopath/src/google.golang.org/grpc/clientconn.go:507 +0x643

```

