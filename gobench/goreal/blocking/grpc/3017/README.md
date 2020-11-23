
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#3017]|[pull request]|[patch]| Blocking | Resource Deadlock | Double Locking |

[grpc#3017]:(grpc3017_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/3017/files
[pull request]:https://github.com/grpc/grpc-go/pull/3017
 
## Description

Some description from developers or pervious reseachers

> Before the fix, if the timer to remove a SubConn fires at the same time
  NewSubConn cancels the timer, it caused a mutex leak and deadlock.

See the [bug kernel](../../../../goker/blocking/grpc/3017/README.md)

## Backtrace

```
goroutine 19 [chan receive]:
github.com/golang/glog.(*loggingT).flushDaemon(0xdb8e80)
    /go/pkg/mod/github.com/golang/glog@v0.0.0-20160126235308-23def4e6c14b/glog.go:882 +0x8b
created by github.com/golang/glog.init.0
    /go/pkg/mod/github.com/golang/glog@v0.0.0-20160126235308-23def4e6c14b/glog.go:410 +0x26f

 Goroutine 22 in state semacquire, with sync.runtime_SemacquireMutex on top of the stack:
goroutine 22 [semacquire]:
sync.runtime_SemacquireMutex(0xc000091f0c, 0xc00003b500, 0x1)
    /usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc000091f08)
    /usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
    /usr/local/go/src/sync/mutex.go:81
google.golang.org/grpc/balancer/grpclb.(*lbCacheClientConn).NewSubConn(0xc000091ef0, 0xc000149540, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
    /go/src/google.golang.org/grpc/balancer/grpclb/grpclb_util.go:131 +0x40f
google.golang.org/grpc/balancer/grpclb.TestLBCache_RemoveTimer_New_Race.func1(0xc000091ef0, 0xc00008d4b0, 0xc000082420)
    /go/src/google.golang.org/grpc/balancer/grpclb/grpclb_util_test.go:255 +0xd5
created by google.golang.org/grpc/balancer/grpclb.TestLBCache_RemoveTimer_New_Race
    /go/src/google.golang.org/grpc/balancer/grpclb/grpclb_util_test.go:250 +0x467

 Goroutine 6 in state semacquire, with sync.runtime_SemacquireMutex on top of the stack:
goroutine 6 [semacquire]:
sync.runtime_SemacquireMutex(0xc000091f0c, 0x0, 0x1)
    /usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc000091f08)
    /usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
    /usr/local/go/src/sync/mutex.go:81
google.golang.org/grpc/balancer/grpclb.(*lbCacheClientConn).RemoveSubConn.func1()
    /go/src/google.golang.org/grpc/balancer/grpclb/grpclb_util.go:175 +0x184
created by time.goFunc
    /usr/local/go/src/time/sleep.go:168 +0x44
```

