
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#79631]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#79631]:(kubernetes79631_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/79631/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/79631
 

## Backtrace

```
Write at 0x00c000390420 by goroutine 37:
  runtime.mapdelete_faststr()
      /usr/local/go/src/runtime/map_faststr.go:297 +0x0
  k8s.io/kubernetes/pkg/scheduler/util.(*heapData).Pop()
      /go/src/k8s.io/kubernetes/pkg/scheduler/util/heap.go:113 +0x1fd
  container/heap.Pop()
      /usr/local/go/src/container/heap/heap.go:64 +0xb0
  k8s.io/kubernetes/pkg/scheduler/util.(*Heap).Pop()
      /go/src/k8s.io/kubernetes/pkg/scheduler/util/heap.go:200 +0x5b
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:356 +0x4aa
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted-fm()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:334 +0x41
  k8s.io/apimachinery/pkg/util/wait.JitterUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:152 +0x6f
  k8s.io/apimachinery/pkg/util/wait.JitterUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:153 +0x108
  k8s.io/apimachinery/pkg/util/wait.Until()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:88 +0x5a

Previous read at 0x00c000390420 by goroutine 36:
  [failed to restore the stack]

Goroutine 37 (running) created at:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).run()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:200 +0xd0
  k8s.io/kubernetes/pkg/scheduler/internal/queue.NewPriorityQueueWithClock()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:193 +0x9b9
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestPriorityQueue_AddUnschedulableIfNotPresent_Backoff()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:164 +0x70
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

```
Write at 0x00c0003906c0 by goroutine 41:
  runtime.mapdelete_faststr()
      /usr/local/go/src/runtime/map_faststr.go:297 +0x0
  k8s.io/kubernetes/pkg/scheduler/util.(*heapData).Pop()
      /go/src/k8s.io/kubernetes/pkg/scheduler/util/heap.go:113 +0x1fd
  container/heap.Pop()
      /usr/local/go/src/container/heap/heap.go:64 +0xb0
  k8s.io/kubernetes/pkg/scheduler/util.(*Heap).Pop()
      /go/src/k8s.io/kubernetes/pkg/scheduler/util/heap.go:200 +0x5b
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:356 +0x4aa
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted-fm()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:334 +0x41
  k8s.io/apimachinery/pkg/util/wait.JitterUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:152 +0x6f
  k8s.io/apimachinery/pkg/util/wait.JitterUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:153 +0x108
  k8s.io/apimachinery/pkg/util/wait.Until()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:88 +0x5a

Previous read at 0x00c0003906c0 by goroutine 40:
  [failed to restore the stack]

Goroutine 41 (running) created at:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).run()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:200 +0xd0
  k8s.io/kubernetes/pkg/scheduler/internal/queue.NewPriorityQueueWithClock()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:193 +0x9b9
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestPriorityQueue_AddUnschedulableIfNotPresent_Backoff()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:164 +0x70
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```
