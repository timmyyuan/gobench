
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#1321]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[kubernetes#1321]:(kubernetes1321_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/1321/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/1321
 
## Description

Some description from developers or pervious reseachers

>  I noticed a potential deadlock scenario with watch.Mux. 
> If a watcher stops reading from its ResultChan and calls Stop, 
> the Mux could be locked in the distribute method attempting to send 
> a new watch.Event to the watcher that's now no longer watching.

See the [bug kernel](../../../../goker/blocking/kubernetes/1321/README.md)

## Backtrace

```
github.com/golang/glog.(*loggingT).flushDaemon(0xb1c220)
    /go/src/k8s.io/kubernetes/Godeps/_workspace/src/github.com/golang/glog/glog.go:839 +0x8b
created by github.com/golang/glog.init.0
    /go/src/k8s.io/kubernetes/Godeps/_workspace/src/github.com/golang/glog/glog.go:406 +0x275

 Goroutine 9 in state chan send, with github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Mux).distribute on top of the stack:
goroutine 9 [chan send]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Mux).distribute(0xc00000e440, 0x81b587, 0x5, 0x89d920, 0xc00000e480)
    /go/src/k8s.io/kubernetes/_output/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:124 +0x11a
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Mux).loop(0xc00000e440)
    /go/src/k8s.io/kubernetes/_output/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:112 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewMux
    /go/src/k8s.io/kubernetes/_output/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:46 +0xa0

 Goroutine 10 in state chan receive, with github.com/GoogleCloudPlatform/kubernetes/pkg/watch.TestMuxWatcherStopDeadlock.func3 on top of the stack:
goroutine 10 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.TestMuxWatcherStopDeadlock.func3(0xc00001a480, 0xc00001a4e0, 0x8a0540, 0xc00000e460)
    /go/src/k8s.io/kubernetes/_output/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux_test.go:108 +0x34
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.TestMuxWatcherStopDeadlock
    /go/src/k8s.io/kubernetes/_output/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux_test.go:105 +0x1bf
```

