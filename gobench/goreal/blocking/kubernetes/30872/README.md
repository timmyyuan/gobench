
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#30872]|[pull request]|[patch]| Blocking | Resource Deadlock | AB-BA Deadlock |

[kubernetes#30872]:(kubernetes30872_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/30872/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/30872
 
## Description

Some description from developers or pervious reseachers

> On cluster add subinformer locks and tries to add cluster to federated informer. When someone checks if everything is in sync federated informer is locked and then subinformer is inspected what apparently requires a lock. With really bad timing this can create a deadlock.
  This PR ensures that there is always at most 1 lock taken in federated informer.

In this bugs, goleak will report too many background goroutines in every single run in our evaluation (e.g. traces below).
These bugs are almost indistinguishable by the IgnoreTopFunction method provided by goleak, 
because they are all worker goroutines. In the backtrace, we mentioned the goroutines that participated 
when the real deadlock occurred. Obviously goleak produced an false positive report before finding the
real deadlock.

```
[Goroutine 13 in state sync.Cond.Wait, with runtime.goparkunlock on top of the stack:
goroutine 13 [sync.Cond.Wait]:
runtime.goparkunlock(...)
    /usr/local/go/src/runtime/proc.go:307
sync.runtime_notifyListWait(0xc0001c84f8, 0xc000000002)
    /usr/local/go/src/runtime/sema.go:510 +0xf9
sync.(*Cond).Wait(0xc0001c84e8)
    /usr/local/go/src/sync/cond.go:56 +0x9e
k8s.io/kubernetes/pkg/client/cache.(*DeltaFIFO).Pop(0xc0001c84d0, 0xc000047860, 0x0, 0x0, 0x0, 0x0)
    /go/src/k8s.io/kubernetes/pkg/client/cache/delta_fifo.go:407 +0x86
k8s.io/kubernetes/pkg/controller/framework.(*Controller).processLoop(0xc000180d20)
    /go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:127 +0x3c
k8s.io/kubernetes/pkg/util/wait.JitterUntil.func1(...)
    /go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:84
k8s.io/kubernetes/pkg/util/wait.JitterUntil(0xc000335fb0, 0x3b9aca00, 0x0, 0xc0003e7001, 0xc0004084e0)
    /go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:85 +0xdc
k8s.io/kubernetes/pkg/util/wait.Until(...)
    /go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:47
k8s.io/kubernetes/pkg/controller/framework.(*Controller).Run(0xc000180d20, 0xc0004084e0)
    /go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:103 +0x1c6
created by k8s.io/kubernetes/federation/pkg/federation-controller/namespace.(*NamespaceController).Run
    /go/src/k8s.io/kubernetes/federation/pkg/federation-controller/namespace/namespace_controller.go:153 +0x54

 Goroutine 14 in state sync.Cond.Wait, with runtime.goparkunlock on top of the stack:
goroutine 14 [sync.Cond.Wait]:
runtime.goparkunlock(...)
    /usr/local/go/src/runtime/proc.go:307
sync.runtime_notifyListWait(0xc0001c85a8, 0xc000000002)
    /usr/local/go/src/runtime/sema.go:510 +0xf9
sync.(*Cond).Wait(0xc0001c8598)
    /usr/local/go/src/sync/cond.go:56 +0x9e
k8s.io/kubernetes/pkg/client/cache.(*DeltaFIFO).Pop(0xc0001c8580, 0xc000047b00, 0x0, 0x0, 0x0, 0x0)
    /go/src/k8s.io/kubernetes/pkg/client/cache/delta_fifo.go:407 +0x86
k8s.io/kubernetes/pkg/controller/framework.(*Controller).processLoop(0xc000180d90)
    /go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:127 +0x3c
k8s.io/kubernetes/pkg/util/wait.JitterUntil.func1(...)
    /go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:84
k8s.io/kubernetes/pkg/util/wait.JitterUntil(0xc00006dfb0, 0x3b9aca00, 0x0, 0xc000188901, 0xc000408540)
    /go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:85 +0xdc
k8s.io/kubernetes/pkg/util/wait.Until(...)
    /go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:47
k8s.io/kubernetes/pkg/controller/framework.(*Controller).Run(0xc000180d90, 0xc000408540)
    /go/src/k8s.io/kubernetes/pkg/controller/framework/controller.go:103 +0x1c6
created by k8s.io/kubernetes/federation/pkg/federation-controller/util.(*federatedInformerImpl).Start
    /go/src/k8s.io/kubernetes/federation/pkg/federation-controller/util/federated_informer.go:274 +0xb0
```


## Backtrace

```
=== RUN   TestNamespaceController
--- PASS: TestNamespaceController (1.07s)
=== RUN   TestNamespaceController
--- PASS: TestNamespaceController (1.07s)
=== RUN   TestNamespaceController
--- FAIL: TestNamespaceController (60.00s)

==== stderr
panic: Expected value not to be nil. [recovered]
	panic: Expected value not to be nil.

goroutine 31 [select]:
k8s.io/kubernetes/pkg/client/cache.(*Reflector).ListAndWatch.func1(0xc000290070, 0xc000044780, 0xc000164480, 0xc00045e2a0, 0xc000290078)
	/go/src/k8s.io/kubernetes/pkg/client/cache/reflector.go:279 +0xa9
created by k8s.io/kubernetes/pkg/client/cache.(*Reflector).ListAndWatch
	/go/src/k8s.io/kubernetes/pkg/client/cache/reflector.go:277 +0x6df

goroutine 30 [select]:
k8s.io/kubernetes/pkg/client/cache.(*Reflector).watchHandler(0xc000164480, 0x1d057e0, 0xc00000e720, 0xc00036fcd8, 0xc00045e2a0, 0xc000044780, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/pkg/client/cache/reflector.go:357 +0x1c0
k8s.io/kubernetes/pkg/client/cache.(*Reflector).ListAndWatch(0xc000164480, 0xc000044780, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/pkg/client/cache/reflector.go:328 +0xc76
k8s.io/kubernetes/pkg/client/cache.(*Reflector).RunUntil.func1()
	/go/src/k8s.io/kubernetes/pkg/client/cache/reflector.go:213 +0x33
k8s.io/kubernetes/pkg/util/wait.JitterUntil.func1(...)
	/go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:84
k8s.io/kubernetes/pkg/util/wait.JitterUntil(0xc00055e320, 0x3b9aca00, 0x0, 0x1, 0xc000044780)
	/go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:85 +0xdc
k8s.io/kubernetes/pkg/util/wait.Until(0xc00055e320, 0x3b9aca00, 0xc000044780)
	/go/src/k8s.io/kubernetes/pkg/util/wait/wait.go:47 +0x4d
created by k8s.io/kubernetes/pkg/client/cache.(*Reflector).RunUntil
	/go/src/k8s.io/kubernetes/pkg/client/cache/reflector.go:212 +0x16c
...

```

