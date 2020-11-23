
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#11298]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel & Condition Variable |

[kubernetes#11298]:(kubernetes11298_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/11298/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/11298
 
## Description

Some description from developers or pervious reseachers

> n.node used the n.lock as underlaying locker. The service loop initially
  locked it, the Notify function tried to lock it before calling n.node.Signal,
  leading to a dead-lock.

See the [bug kernel](../../../../goker/blocking/kubernetes/11298/README.md)

## Backtrace

```
goroutine 386 [chan receive]:
_/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election.Test(0xc0002e7000)
	/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election/master_test.go:83 +0x1a1
testing.tRunner(0xc0002e7000, 0xaa16a0)
	/usr/local/go/src/testing/testing.go:909 +0xc9
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x350

goroutine 12 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc0000899b0, 0xa7fa3e, 0x8, 0xb39140, 0xc0002373a0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc0000899b0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 53 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc00023a0f0, 0xa7fa3e, 0x8, 0xb39140, 0xc00013baa0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc00023a0f0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 199 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298240)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 89 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc0001373e0, 0xa7fa3e, 0x8, 0xb39140, 0xc0002729a0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc0001373e0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 193 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298120)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 187 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298000)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 141 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc000089b00, 0xa7fa3e, 0x8, 0xb39140, 0xc000269770)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000089b00)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 181 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000089ec0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 127 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc000137500, 0xa7fa3e, 0x8, 0xb39140, 0xc0002805b0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000137500)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 153 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000089c80)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 384 [sync.Cond.Wait]:
runtime.goparkunlock(...)
	/usr/local/go/src/runtime/proc.go:310
sync.runtime_notifyListWait(0xc0001549d0, 0x35)
	/usr/local/go/src/runtime/sema.go:510 +0xf8
sync.(*Cond).Wait(0xc0001549c0)
	/usr/local/go/src/sync/cond.go:56 +0x9d
github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime.After.func1(0xc0001dd020, 0xc000333990)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime/util.go:95 +0x9c
created by github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime.After
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime/util.go:91 +0x62

goroutine 159 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000089da0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 205 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298360)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 211 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298480)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 217 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc0002985a0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 223 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc0002986c0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 229 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc0002987e0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 235 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298900)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 241 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298a20)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 247 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298b40)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 253 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298c60)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 259 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298d80)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 265 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298ea0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 271 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000298fc0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 277 [chan receive]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc0002990e0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:159 +0x7b
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 283 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc000299200, 0xa7fa3e, 0x8, 0xb39140, 0xc00031a7a0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000299200)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 327 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc000299350, 0xa7fa3e, 0x8, 0xb39140, 0xc00032fa60)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc000299350)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1

goroutine 388 [chan receive]:
_/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election.(*notifier).serviceLoop(0xc0000f4870, 0xc000149a40)
	/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election/master.go:119 +0x1c3
_/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election.Notify.func2()
	/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election/master.go:102 +0x33
github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime.Until.func1(0xc00032d6c8)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime/util.go:115 +0x4d
github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime.Until(0xc00031cec8, 0x0, 0xc000330480)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime/util.go:116 +0x76
_/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election.Notify(0xb380a0, 0xc00000fd20, 0x0, 0x0, 0xa7c082, 0x2, 0xb40a80, 0xc00000fd40, 0xc000330480)
	/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election/master.go:102 +0x1a4
_/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election.Test.func1()
	/go/src/k8s.io/kubernetes/contrib/mesos/pkg/election/master_test.go:72 +0x71
github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime.After.func1(0xc0003304e0, 0xc00000fd60)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime/util.go:95 +0x9c
created by github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime.After
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/contrib/mesos/pkg/runtime/util.go:91 +0x62

goroutine 387 [select]:
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).distribute(0xc0002994a0, 0xa7fa3e, 0x8, 0xb39140, 0xc000325cc0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:182 +0x362
github.com/GoogleCloudPlatform/kubernetes/pkg/watch.(*Broadcaster).loop(0xc0002994a0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:163 +0x45
created by github.com/GoogleCloudPlatform/kubernetes/pkg/watch.NewBroadcaster
	/go/src/k8s.io/kubernetes/_output/local/go/src/github.com/GoogleCloudPlatform/kubernetes/pkg/watch/mux.go:70 +0xb1
```

