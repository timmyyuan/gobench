
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#26980]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[kubernetes#26980]:(kubernetes26980_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/26980/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/26980
 
## Description

Some description from developers or pervious reseachers

> Currently the lock in processorListener is used to guard pendingNotifications. 
> But in pop, it also locks around on select chan. This will block the goroutine 
> with lock acquired.


## Backtrace

```
goroutine 19 [chan receive]:
k8s.io/kubernetes/vendor/github.com/golang/glog.(*loggingT).flushDaemon(0x1a34fe0)
	/go/src/k8s.io/kubernetes/vendor/github.com/golang/glog/glog.go:879 +0x8b
created by k8s.io/kubernetes/vendor/github.com/golang/glog.init.0
	/go/src/k8s.io/kubernetes/vendor/github.com/golang/glog/glog.go:410 +0x272

goroutine 342 [runnable]:
sync.runtime_SemacquireMutex(0xc000460984, 0xef1400)
	/usr/local/go/src/runtime/sema.go:71 +0x3d
sync.(*Mutex).Lock(0xc000460980)
	/usr/local/go/src/sync/mutex.go:134 +0x109
sync.(*RWMutex).Lock(0xc000460980)
	/usr/local/go/src/sync/rwmutex.go:93 +0x2d
k8s.io/kubernetes/pkg/controller/framework.TestPopReleaseLock.func1(0xc000460980, 0xc00047a7e0)
	/go/src/k8s.io/kubernetes/pkg/controller/framework/processor_listener_test.go:40 +0x2d
created by k8s.io/kubernetes/pkg/controller/framework.TestPopReleaseLock
	/go/src/k8s.io/kubernetes/pkg/controller/framework/processor_listener_test.go:39 +0x1c0
```

