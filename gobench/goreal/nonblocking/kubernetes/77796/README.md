
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#77796]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#77796]:(kubernetes77796_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/77796/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/77796
 

## Backtrace

```
Read at 0x00c000461c78 by goroutine 18:
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvent()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:792 +0xde
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop.func1()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:682 +0x42

Previous write at 0x00c000461c78 by goroutine 87:
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).startDispatching()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:833 +0x137
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvent()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:786 +0x5d
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop.func1()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:682 +0x42

Goroutine 18 (running) created at:
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:681 +0x8b3
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 87 (finished) created at:
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:681 +0x8b3
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

