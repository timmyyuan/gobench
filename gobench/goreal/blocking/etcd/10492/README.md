
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[etcd#10492]|[pull request]|[patch]| Blocking | Resource Deadlock | Double Locking |

[etcd#10492]:(etcd10492_test.go)
[patch]:https://github.com/etcd-io/etcd/pull/10492/files
[pull request]:https://github.com/etcd-io/etcd/pull/10492
 
## Description

Some description from developers or pervious reseachers

> There is a deadlock issue which block the write. when we 
> renew a lease that have remaining TTL cause by the long TTL 
> setting, it write lease checkpointing entry to raft and wait 
> it apply, but apply this entry also need acquire the same lock 
> which already acquired by renew, and then meet the deadlock 
> until timeout.

See its [bug kernel](../../../../goker/blocking/etcd/10492/README.md)

## Backtrace

```
goroutine 13 [semacquire]:
sync.runtime_SemacquireMutex(0xc0000a1ef4, 0x0, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc0000a1ef0)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
	/usr/local/go/src/sync/mutex.go:81
sync.(*RWMutex).Lock(0xc0000a1ef0)
	/usr/local/go/src/sync/rwmutex.go:98 +0x97
go.etcd.io/etcd/lease.(*lessor).Checkpoint(0xc0000a1ef0, 0x1, 0x0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/lease/lessor.go:335 +0x3c
go.etcd.io/etcd/lease.TestLessorRenewWithCheckpointer.func1(0xbf14c0, 0xc000026050, 0xc00000f0c0)
	/go/src/github.com/coreos/etcd/lease/lessor_test.go:248 +0x5c
go.etcd.io/etcd/lease.(*lessor).Renew(0xc0000a1ef0, 0x1, 0x0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/lease/lessor.go:391 +0x362
go.etcd.io/etcd/lease.TestLessorRenewWithCheckpointer(0xc000168100)
	/go/src/github.com/coreos/etcd/lease/lessor_test.go:266 +0x3a4
testing.tRunner(0xc000168100, 0xb3d128)
	/usr/local/go/src/testing/testing.go:909 +0xc9
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x350

goroutine 14 [select]:
go.etcd.io/etcd/mvcc/backend.(*backend).run(0xc000114a10)
	/go/src/github.com/coreos/etcd/mvcc/backend/backend.go:297 +0x172
created by go.etcd.io/etcd/mvcc/backend.newBackend
	/go/src/github.com/coreos/etcd/mvcc/backend/backend.go:177 +0x560

goroutine 15 [semacquire]:
sync.runtime_SemacquireMutex(0xc0000a1efc, 0x0, 0x0)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*RWMutex).RLock(...)
	/usr/local/go/src/sync/rwmutex.go:50
go.etcd.io/etcd/lease.(*lessor).revokeExpiredLeases(0xc0000a1ef0)
	/go/src/github.com/coreos/etcd/lease/lessor.go:591 +0x201
go.etcd.io/etcd/lease.(*lessor).runLoop(0xc0000a1ef0)
	/go/src/github.com/coreos/etcd/lease/lessor.go:572 +0x7e
created by go.etcd.io/etcd/lease.newLessor
	/go/src/github.com/coreos/etcd/lease/lessor.go:208 +0x20f
```

