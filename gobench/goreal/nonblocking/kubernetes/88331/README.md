
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#88331]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#88331]:(kubernetes88331_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/88331/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/88331
 

## Backtrace

```
Write at 0x00c0062036b8 by goroutine 6918:
  k8s.io/kubernetes/pkg/scheduler/internal/heap.(*data).Pop()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/heap/heap.go:107 +0x130
  container/heap.Pop()
      /usr/local/go/src/container/heap/heap.go:64 +0xb0
  k8s.io/kubernetes/pkg/scheduler/internal/heap.(*Heap).Pop()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/heap/heap.go:200 +0x5b
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:338 +0x23f
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted-fm()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:325 +0x41
  k8s.io/apimachinery/pkg/util/wait.BackoffUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:155 +0x6f
  k8s.io/apimachinery/pkg/util/wait.BackoffUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:156 +0xb3
  k8s.io/apimachinery/pkg/util/wait.JitterUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:133 +0x145
  k8s.io/apimachinery/pkg/util/wait.Until()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:90 +0x5a

Previous read at 0x00c0062036b8 by goroutine 5491:
  [failed to restore the stack]

Goroutine 6918 (running) created at:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).Run()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:235 +0xd0
  k8s.io/kubernetes/pkg/scheduler/internal/queue.createAndRunPriorityQueue()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue_test.go:1514 +0x73
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestPriorityQueue_MoveAllToActiveOrBackoffQueue()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue_test.go:383 +0x5a
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

```
Write at 0x00c0062250b8 by goroutine 6920:
  k8s.io/kubernetes/pkg/scheduler/internal/heap.(*data).Push()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/heap/heap.go:101 +0x293
  container/heap.Push()
      /usr/local/go/src/container/heap/heap.go:53 +0x56
  k8s.io/kubernetes/pkg/scheduler/internal/heap.(*Heap).Add()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/heap/heap.go:147 +0x3ac
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:343 +0x28c
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).flushBackoffQCompleted-fm()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:325 +0x41
  k8s.io/apimachinery/pkg/util/wait.BackoffUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:155 +0x6f
  k8s.io/apimachinery/pkg/util/wait.BackoffUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:156 +0xb3
  k8s.io/apimachinery/pkg/util/wait.JitterUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:133 +0x145
  k8s.io/apimachinery/pkg/util/wait.Until()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:90 +0x5a

Previous read at 0x00c0062250b8 by goroutine 4840:
  [failed to restore the stack]

Goroutine 6920 (running) created at:
  k8s.io/kubernetes/pkg/scheduler/internal/queue.(*PriorityQueue).Run()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue.go:235 +0xd0
  k8s.io/kubernetes/pkg/scheduler/internal/queue.createAndRunPriorityQueue()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue_test.go:1514 +0x73
  k8s.io/kubernetes/pkg/scheduler/internal/queue.TestPriorityQueue_MoveAllToActiveOrBackoffQueue()
      /go/src/k8s.io/kubernetes/pkg/scheduler/internal/queue/scheduling_queue_test.go:383 +0x5a
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```
