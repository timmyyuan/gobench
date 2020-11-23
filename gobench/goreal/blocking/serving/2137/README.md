
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#2137]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[serving#2137]:(serving2137_test.go)
[patch]:https://github.com/knative/serving/pull/2137/files
[pull request]:https://github.com/knative/serving/pull/2137
 
## Description

Some description from developers or pervious reseachers

> Fix race condition in pkg/queue/breaker_test.go which results in occasional
  deadlocks and flakey tests. The order that requests were performed was not
  deterministic, but the tests expect them to be ordered.


See the [bug kernel](../../../../goker/blocking/serving/2137/README.md)

## Backtrace

```
goroutine 19 [chan receive]:
github.com/knative/serving/vendor/github.com/golang/glog.(*loggingT).flushDaemon(0x1ee31a0)
	/go/src/github.com/knative/serving/vendor/github.com/golang/glog/glog.go:882 +0xac
created by github.com/knative/serving/vendor/github.com/golang/glog.init.0
	/go/src/github.com/knative/serving/vendor/github.com/golang/glog/glog.go:410 +0x231

goroutine 21 [select]:
github.com/knative/serving/vendor/go.opencensus.io/stats/view.(*worker).start(0xc4200b4e00)
	/go/src/github.com/knative/serving/vendor/go.opencensus.io/stats/view/worker.go:144 +0x18f
created by github.com/knative/serving/vendor/go.opencensus.io/stats/view.init.0
	/go/src/github.com/knative/serving/vendor/go.opencensus.io/stats/view/worker.go:29 +0x9b

goroutine 3826 [chan send]:
github.com/knative/serving/pkg/queue.(*Breaker).Maybe(0xc420401bc0, 0xc4202b7f98, 0x0)
	/go/src/github.com/knative/serving/pkg/queue/breaker.go:63 +0x9d
github.com/knative/serving/pkg/queue.(*Breaker).concurrentRequest.func1(0xc4204818e0, 0xc420401bc0, 0xc4204818d0, 0xc4204aff10)
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:125 +0xab
created by github.com/knative/serving/pkg/queue.(*Breaker).concurrentRequest
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:123 +0x121

goroutine 3783 [semacquire]:
sync.runtime_SemacquireMutex(0xc420439d34, 0x900000000)
	/usr/local/go/src/runtime/sema.go:71 +0x3d
sync.(*Mutex).Lock(0xc420439d30)
	/usr/local/go/src/sync/mutex.go:134 +0x172
github.com/knative/serving/pkg/queue.(*Breaker).concurrentRequest.func1.1()
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:126 +0x47
github.com/knative/serving/pkg/queue.(*Breaker).Maybe(0xc420401bc0, 0xc4203c3f98, 0x0)
	/go/src/github.com/knative/serving/pkg/queue/breaker.go:67 +0xcd
github.com/knative/serving/pkg/queue.(*Breaker).concurrentRequest.func1(0xc420439d40, 0xc420401bc0, 0xc420439d30, 0xc4204bf340)
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:125 +0xab
created by github.com/knative/serving/pkg/queue.(*Breaker).concurrentRequest
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:123 +0x121

goroutine 3823 [chan receive]:
github.com/knative/serving/pkg/queue.unlock(0xc4204818d0, 0xc4204aff10)
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:156 +0x56
github.com/knative/serving/pkg/queue.unlockAll(0xc4203fedc0, 0x4, 0x4)
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:163 +0x6e
github.com/knative/serving/pkg/queue.TestBreakerRecover(0xc4204b5b30)
	/go/src/github.com/knative/serving/pkg/queue/breaker_test.go:68 +0xfb
testing.tRunner(0xc4204b5b30, 0x1a8d640)
	/usr/local/go/src/testing/testing.go:777 +0x16e
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:824 +0x565
```

