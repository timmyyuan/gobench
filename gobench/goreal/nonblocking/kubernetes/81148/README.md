
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#81148]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#81148]:(kubernetes81148_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/81148/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/81148
 

## Backtrace

```
Read at 0x00c000309688 by goroutine 401:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushUnschedulableQLeftover()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:375 +0x236
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushUnschedulableQLeftover-fm()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:368 +0x41
  k8s.io/apimachinery/pkg/util/wait.JitterUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:152 +0x6f
  k8s.io/apimachinery/pkg/util/wait.JitterUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:153 +0x108
  k8s.io/apimachinery/pkg/util/wait.Until()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:88 +0x5a

Previous write at 0x00c000309688 by goroutine 138:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestHighPriorityFlushUnschedulableQLeftover()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue_test.go:1060 +0x600
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 401 (running) created at:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).run()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:201 +0x172
  k8s.io/kubernetes/pkg/scheduler/internal/queue.NewPriorityQueueWithClock()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:193 +0x9b9
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestHighPriorityFlushUnschedulableQLeftover()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:164 +0x70
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 138 (running) created at:
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
      _testmain.go:88 +0x223
```

