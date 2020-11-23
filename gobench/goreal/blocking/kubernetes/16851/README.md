
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#16851]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[kubernetes#16851]:(kubernetes16851_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/16851/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/16851
 
## Description

Some description from developers or pervious reseachers.

> The MockPodsListWatch was locking itself for list modifications 
> and then accessed the event channel without unlocking before. 
> This results in a deadlock situation when the listener of the event 
> channel is also the caller of the function which locks. Or in this situation

```go
go func() {
 mock.List()
 mock.Watch()
}()
mock.Add()
```

> This gives a deadlock if the execution order is the following:
> * mock.Add() => lock(), channel<- event => BLOCKED
> * mock.List() => lock() => BLOCKED
> * mock.Watch() is never reached.

It is difficult for goleak to exclude worker goroutines 
through goleak's IgnoreTopFunction(). For example,

```
 Goroutine 192 in state sync.Cond.Wait, with runtime.goparkunlock on top of the stack:
goroutine 192 [sync.Cond.Wait]:
runtime.goparkunlock(...)
    /usr/local/go/src/runtime/proc.go:310
sync.runtime_notifyListWait(0xc0002446f0, 0xc00000000c)
    /usr/local/go/src/runtime/sema.go:510 +0xf8
sync.(*Cond).Wait(0xc0002446e0)
    /usr/local/go/src/sync/cond.go:56 +0x9d
k8s.io/kubernetes/contrib/mesos/pkg/runtime.After.func1(0xc00009ef00, 0xc000240d80)
    /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/runtime/util.go:95 +0xc7
created by k8s.io/kubernetes/contrib/mesos/pkg/runtime.After
    /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/runtime/util.go:91 +0x62
```

## Backtrace

```
goroutine 40 [chan receive]:
k8s.io/kubernetes/pkg/watch.(*Broadcaster).loop(0xc82028a5c0)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/watch/mux.go:198 +0x58
created by k8s.io/kubernetes/pkg/watch.NewBroadcaster
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/watch/mux.go:74 +0x128

goroutine 42 [select]:
k8s.io/kubernetes/contrib/mesos/pkg/scheduler.(_queuer).yield(0xc8201a9560, 0x0)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/scheduler/plugin.go:477 +0x485
k8s.io/kubernetes/contrib/mesos/pkg/scheduler.(_queuer).(k8s.io/kubernetes/contrib/mesos/pkg/scheduler.yield)-fm(0x0)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/scheduler/plugin.go:701 +0x20
k8s.io/kubernetes/contrib/mesos/pkg/scheduler.(_schedulingPlugin).scheduleOne(0xc82028a680)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/scheduler/plugin.go:750 +0x37
k8s.io/kubernetes/contrib/mesos/pkg/scheduler.(_schedulingPlugin).(k8s.io/kubernetes/contrib/mesos/pkg/scheduler.scheduleOne)-fm()
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/scheduler/plugin.go:744 +0x20
k8s.io/kubernetes/contrib/mesos/pkg/runtime.Until.func1(0xc8202a5140)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/runtime/util.go:115 +0x4b
k8s.io/kubernetes/contrib/mesos/pkg/runtime.Until(0xc8202a5140, 0x5f5e100, 0xc82021d740)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/runtime/util.go:116 +0x7f
created by k8s.io/kubernetes/contrib/mesos/pkg/scheduler.(*schedulingPlugin).Run
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/scheduler/plugin.go:744 +0xac

goroutine 43 [semacquire]:
sync.runtime_Syncsemacquire(0xc82027b000)
/usr/local/go/src/runtime/sema.go:237 +0x201
sync.(_Cond).Wait(0xc82027aff0)
/usr/local/go/src/sync/cond.go:62 +0x9b
k8s.io/kubernetes/contrib/mesos/pkg/queue.(_DelayQueue).Pop.func1(0x0)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/queue/delay.go:133 +0xbf
k8s.io/kubernetes/contrib/mesos/pkg/queue.(_DelayQueue).pop(0xc82027afc0, 0xc820048df8, 0x0, 0x0, 0x0)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/queue/delay.go:146 +0x5b
k8s.io/kubernetes/contrib/mesos/pkg/queue.(_DelayQueue).Pop(0xc82027afc0, 0x0, 0x0)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/queue/delay.go:138 +0x4e
k8s.io/kubernetes/contrib/mesos/pkg/offers.(_offerStorage).ageOffers(0xc8202d84b0)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/offers/offers.go:429 +0x2f
k8s.io/kubernetes/contrib/mesos/pkg/offers.(_offerStorage).(k8s.io/kubernetes/contrib/mesos/pkg/offers.ageOffers)-fm()
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/offers/offers.go:492 +0x20
k8s.io/kubernetes/contrib/mesos/pkg/runtime.Until.func1(0xc8202a5170)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/runtime/util.go:115 +0x4b
k8s.io/kubernetes/contrib/mesos/pkg/runtime.Until(0xc8202a5170, 0x0, 0xc82021d740)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/runtime/util.go:116 +0x7f
created by k8s.io/kubernetes/contrib/mesos/pkg/offers.(*offerStorage).Init
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/offers/offers.go:492 +0x81

goroutine 32 [chan send]:
k8s.io/kubernetes/contrib/mesos/pkg/scheduler.(*MockPodsListWatch).Add(0xc82013f480, 0xc8203be200, 0xc8202e8001)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/scheduler/plugin_test.go:208 +0x1c9
k8s.io/kubernetes/contrib/mesos/pkg/scheduler.TestPlugin_LifeCycle(0xc8201a9320)
/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/contrib/mesos/pkg/scheduler/plugin_test.go:614 +0x35c
testing.tRunner(0xc8201a9320, 0x1ce5dd0)
/usr/local/go/src/testing/testing.go:456 +0x98
created by testing.RunTests
/usr/local/go/src/testing/testing.go:568 +0x86d

...
```

