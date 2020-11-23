
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#73022]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#73022]:(kubernetes73022_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/73022/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/73022
 

## Backtrace

```
Write at 0x00c0000461e0 by goroutine 13:
  runtime.mapassign_faststr()
      /usr/local/go/src/runtime/map_faststr.go:202 +0x0
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestPriorityQueue_AssignedPodAdded()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:735 +0x6c0
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Previous read at 0x00c0000461e0 by goroutine 15:
  runtime.mapiterinit()
      /usr/local/go/src/runtime/map.go:802 +0x0
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushUnschedulableQLeftover()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:459 +0x177
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushUnschedulableQLeftover-fm()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:453 +0x41
  k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/util/wait.JitterUntil.func1()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/util/wait/wait.go:133 +0x6f
  k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/util/wait.JitterUntil()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/util/wait/wait.go:134 +0x108
  k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/util/wait.Until()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/util/wait/wait.go:88 +0x5a

Goroutine 13 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:960 +0x651
  testing.runTests.func1()
      /usr/local/go/src/testing/testing.go:1202 +0xa6
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
  testing.runTests()
      /usr/local/go/src/testing/testing.go:1200 +0x521
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:1117 +0x2ff
  main.main()
      _testmain.go:76 +0x223

Goroutine 15 (running) created at:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).run()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:286 +0x172
  k8s.io/kubernetes/pkg/scheduler/internal/queue.NewPriorityQueueWithClock()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:278 +0x8ab
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestPriorityQueue_AssignedPodAdded()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:262 +0x5f6
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

