
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#70892]|[pull request]|[patch]| NonBlocking | Go-Specific | Anonymous Function |

[kubernetes#70892]:(kubernetes70892_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/70892/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/70892
 

## Backtrace

```
Write at 0x00c000590b40 by goroutine 9:
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes.func2()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:668 +0x454
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil.func1()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:65 +0xcf

Previous read at 0x00c000590b40 by goroutine 10:
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes.func2()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:667 +0x2ee
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil.func1()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:65 +0xcf

Goroutine 9 (running) created at:
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:57 +0x1a6
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:682 +0x52d
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).Schedule()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:186 +0xb3a
  k8s.io/kubernetes/pkg/scheduler/core.TestGenericScheduler.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:464 +0x868
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 10 (running) created at:
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:57 +0x1a6
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:682 +0x52d
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).Schedule()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:186 +0xb3a
  k8s.io/kubernetes/pkg/scheduler/core.TestGenericScheduler.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:464 +0x868
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

```
Write at 0x00c000590b40 by goroutine 10:
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes.func2()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:668 +0x454
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil.func1()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:65 +0xcf

Previous write at 0x00c000590b40 by goroutine 9:
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes.func2()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:668 +0x454
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil.func1()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:65 +0xcf

Goroutine 10 (running) created at:
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:57 +0x1a6
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:682 +0x52d
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).Schedule()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:186 +0xb3a
  k8s.io/kubernetes/pkg/scheduler/core.TestGenericScheduler.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:464 +0x868
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 9 (running) created at:
  k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue.ParallelizeUntil()
      /go/src/k8s.io/kubernetes/vendor/k8s.io/client-go/util/workqueue/parallelizer.go:57 +0x1a6
  k8s.io/kubernetes/pkg/scheduler/core.PrioritizeNodes()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:682 +0x52d
  k8s.io/kubernetes/pkg/scheduler/core.(*genericScheduler).Schedule()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler.go:186 +0xb3a
  k8s.io/kubernetes/pkg/scheduler/core.TestGenericScheduler.func1()
      /go/src/k8s.io/kubernetes/pkg/scheduler/core/generic_scheduler_test.go:464 +0x868
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```
