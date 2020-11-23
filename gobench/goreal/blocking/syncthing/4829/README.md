
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[syncthing#4829]|[pull request]|[patch]| Blocking | Resource Deadlock | Double Locking |

[syncthing#4829]:(syncthing4829_test.go)
[patch]:https://github.com/syncthing/syncthing/pull/4829/files
[pull request]:https://github.com/syncthing/syncthing/pull/4829
 
## Description

Some description from developers or pervious reseachers

> clearAddresses write locks the struct and then calls notify. notify in turn tries to 
> obtain a read lock on the same mutex. The result was a deadlock. 

See the [bug kernel](../../../../goker/blocking/syncthing/4829/README.md)

## Backtrace

```
goroutine 6 [semacquire]:
sync.runtime_SemacquireMutex(0xc00000c08c, 0xc00007ad00, 0x0)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*RWMutex).RLock(...)
	/usr/local/go/src/sync/rwmutex.go:50
command-line-arguments.(*Mapping).notify(0xc00000c080, 0x0, 0x0, 0x0, 0xc0000140f8, 0x1, 0x1)
	/root/gobench/evaluation/gobench-goleak/goker/blocking/syncthing/4829/syncthing4829_test.go:31 +0x77
command-line-arguments.(*Mapping).clearAddresses(0xc00000c080)
	/root/gobench/evaluation/gobench-goleak/goker/blocking/syncthing/4829/syncthing4829_test.go:25 +0x1cf
command-line-arguments.(*Service).RemoveMapping(0xc0000782d0, 0xc00000c080)
	/root/gobench/evaluation/gobench-goleak/goker/blocking/syncthing/4829/syncthing4829_test.go:56 +0x93
command-line-arguments.TestSyncthing4829(0xc000122120)
	/root/gobench/evaluation/gobench-goleak/goker/blocking/syncthing/4829/syncthing4829_test.go:71 +0xf3
testing.tRunner(0xc000122120, 0x551b78)
	/usr/local/go/src/testing/testing.go:1050 +0xdc
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:1095 +0x28b
```

