
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#89164]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#89164]:(kubernetes89164_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/89164/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/89164
 

## Backtrace

```
Write at 0x00c000250678 by goroutine 114:
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).startDispatching()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:962 +0x137
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvent()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:862 +0x60
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvents()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:803 +0x7aa

Previous read at 0x00c000250678 by goroutine 41:
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvent()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:870 +0xed
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop.func1()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:796 +0x42

Goroutine 114 (running) created at:
  k8s.io/apiserver/pkg/storage/cacher.NewCacherFromConfig()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:386 +0xbe3
  k8s.io/apiserver/pkg/storage/cacher.newTestCacher()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:275 +0x425
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:752 +0x13a
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 41 (running) created at:
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:795 +0x9db
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

```
Write at 0x00c000148100 by goroutine 114:
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).startDispatching()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:972 +0x2ad
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvent()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:862 +0x60
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvents()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:803 +0x7aa

Previous read at 0x00c000148100 by goroutine 41:
  k8s.io/apiserver/pkg/storage/cacher.(*Cacher).dispatchEvent()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:870 +0x129
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop.func1()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:796 +0x42

Goroutine 114 (running) created at:
  k8s.io/apiserver/pkg/storage/cacher.NewCacherFromConfig()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher.go:386 +0xbe3
  k8s.io/apiserver/pkg/storage/cacher.newTestCacher()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:275 +0x425
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:752 +0x13a
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 41 (running) created at:
  k8s.io/apiserver/pkg/storage/cacher.TestDispatchingBookmarkEventsWithConcurrentStop()
      /go/src/k8s.io/apiserver/pkg/storage/cacher/cacher_whitebox_test.go:795 +0x9db
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```
