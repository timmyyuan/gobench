
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[istio#16224]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[istio#16224]:(istio16224_test.go)
[patch]:https://github.com/istio/istio/pull/16224/files
[pull request]:https://github.com/istio/istio/pull/16224
 
## Description

Some description from developers or pervious reseachers

> This had a deadlock cases, where we acquire the lock, then try to send
  on the done channel, but we also try to acquire the lock before
  recieving on the done channel. Easy fix here is to release the lock
  before sending on done channel.

See the [bug kernel](../../../../goker/blocking/istio/16224/README.md)

## Backtrace

```
goroutine 20 [select]:
go.opencensus.io/stats/view.(*worker).start(0xc0000dae10)
    /go/pkg/mod/go.opencensus.io@v0.21.0/stats/view/worker.go:154 +0x100
created by go.opencensus.io/stats/view.init.0
    /go/pkg/mod/go.opencensus.io@v0.21.0/stats/view/worker.go:32 +0x57

 Goroutine 7 in state chan receive, with istio.io/istio/pilot/pkg/config/memory.(*configstoreMonitor).Run on top of the stack:
goroutine 7 [chan receive]:
istio.io/istio/pilot/pkg/config/memory.(*configstoreMonitor).Run(0xc00000e340, 0xc000044420)
    /go/src/istio.io/istio/pilot/pkg/config/memory/monitor.go:77 +0x1b0
istio.io/istio/pilot/pkg/config/memory.(*controller).Run(0xc00000e360, 0xc000044420)
    /go/src/istio.io/istio/pilot/pkg/config/memory/controller.go:49 +0x3d
created by istio.io/istio/pilot/pkg/config/memory_test.TestEventConsistency
    /go/src/istio.io/istio/pilot/pkg/config/memory/monitor_test.go:54 +0x33d
```

