
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[etcd#6708]|[pull request]|[patch]| Blocking | Resource Deadlock | Double Locking |

[etcd#6708]:(etcd6708_test.go)
[patch]:https://github.com/etcd-io/etcd/pull/6708/files
[pull request]:https://github.com/etcd-io/etcd/pull/6708
 
## Description

Some description from developers or pervious reseachers

> So, if you used EndpointSelectionPrioritizeLeader and Sync 
> ever actually attempted to prioritise the leader (the fast 
> exit on endpoint equality would prevent this almost always), 
> you'd get a deadlock. This'd happen as Sync would take a write lock, 
> and then call c.getLeaderEndpoint -> MemberAPI(c) -> c.Do, which 
> would then attempt to take a read lock. Nicht sehr gut! I've added 
> a test TestHTTPClusterClientSyncPinLeaderEndpoint which replicates 
> this behaviour when run against master.

See its [bug kernel](../../../../goker/blocking/etcd/6708/README.md)

## Backtrace

```
goroutine 19 [semacquire]:
sync.runtime_SemacquireMutex(0xc0000f233c, 0xc00011a100, 0x0)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*RWMutex).RLock(...)
	/usr/local/go/src/sync/rwmutex.go:50
github.com/coreos/etcd/client.(*httpClusterClient).Do(0xc0000f2300, 0xb21240, 0xc000026050, 0xb18140, 0xec44d0, 0x7fbfb41d80c8, 0x0, 0xc00015ba80, 0x630652, 0xc00011a180, ...)
	/go/src/github.com/coreos/etcd/client/client.go:316 +0xd64
github.com/coreos/etcd/client.(*httpMembersAPI).Leader(0xc0000f6640, 0xb21240, 0xc000026050, 0x7fbfb41d80c8, 0xc0000f2300, 0x0)
	/go/src/github.com/coreos/etcd/client/members.go:208 +0x7a
github.com/coreos/etcd/client.(*httpClusterClient).getLeaderEndpoint(0xc0000f2300, 0x15, 0xc00012e300, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/client/client.go:266 +0xae
github.com/coreos/etcd/client.(*httpClusterClient).SetEndpoints(0xc0000f2300, 0xc0000f2360, 0x4, 0x6, 0xc0000fe800, 0x1)
	/go/src/github.com/coreos/etcd/client/client.go:294 +0x143
github.com/coreos/etcd/client.(*httpClusterClient).Sync(0xc0000f2300, 0xb21240, 0xc000026050, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/client/client.go:424 +0x517
github.com/coreos/etcd/client.TestHTTPClusterClientSyncPinLeaderEndpoint(0xc000134100)
	/go/src/github.com/coreos/etcd/client/client_test.go:975 +0x743
testing.tRunner(0xc000134100, 0xa8b090)
	/usr/local/go/src/testing/testing.go:909 +0xc9
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x350
```

