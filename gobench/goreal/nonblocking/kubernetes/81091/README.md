
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#81091]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#81091]:(kubernetes81091_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/81091/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/81091
 

## Backtrace

```
Read at 0x000002c40e70 by goroutine 160:
  k8s.io/kubernetes/pkg/scheduler/core.(*FakeFilterPlugin).Filter()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:165 +0x41
  k8s.io/kubernetes/pkg/scheduler/framework/v1alpha1.(*framework).RunFilterPlugins()
      /go/src/k8s.io/kubernetes/pkg/scheduler/framework/v1alpha1/framework.go:316 +0xf7
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).findNodesThatFit.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:508 +0x349
  k8s.io/client-go/util/workqueue.ParallelizeUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/client-go/util/workqueue/parallelizer.go:57 +0xcf

Previous write at 0x000002c40e70 by goroutine 200:
  k8s.io/kubernetes/pkg/scheduler/core.(*FakeFilterPlugin).Filter()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:165 +0x5a
  k8s.io/kubernetes/pkg/scheduler/framework/v1alpha1.(*framework).RunFilterPlugins()
      /go/src/k8s.io/kubernetes/pkg/scheduler/framework/v1alpha1/framework.go:316 +0xf7
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).findNodesThatFit.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:508 +0x349
  k8s.io/client-go/util/workqueue.ParallelizeUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/client-go/util/workqueue/parallelizer.go:57 +0xcf

Goroutine 160 (running) created at:
  k8s.io/client-go/util/workqueue.ParallelizeUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/client-go/util/workqueue/parallelizer.go:49 +0x1a6
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).findNodesThatFit()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:535 +0xfe5
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).Schedule()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:214 +0x5fe
  k8s.io/kubernetes/pkg/scheduler/core.TestGenericScheduler.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:654 +0x8a2
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 200 (finished) created at:
  k8s.io/client-go/util/workqueue.ParallelizeUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/client-go/util/workqueue/parallelizer.go:49 +0x1a6
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).findNodesThatFit()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:535 +0xfe5
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).Schedule()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:214 +0x5fe
  k8s.io/kubernetes/pkg/scheduler/core.TestGenericScheduler.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:654 +0x8a2
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

