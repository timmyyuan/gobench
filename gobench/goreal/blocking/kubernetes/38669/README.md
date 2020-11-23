
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#38669]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[kubernetes#38669]:(kubernetes38669_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/38669/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/38669
 
## Description

Some description from developers or pervious reseachers

> The root cause is: if the WatchServer timeout [fires] when the result 
  channel is full, sendWatchCacheEvent will be blocked on the write to 
> the result even though cacheWatch.Stop() is [called], because WatchServer 
> stops consuming the result channel after the timeout.

[fires]:https://github.com/kubernetes/kubernetes/blob/master/pkg/apiserver/watch.go#L187-L188
[called]: https://github.com/kubernetes/kubernetes/blob/master/pkg/apiserver/watch.go#L171

See the [bug kernel](../../../../goker/blocking/kubernetes/38669/README.md)

## Backtrace

```
goroutine 20 [chan receive]:
k8s.io/kubernetes/vendor/github.com/golang/glog.(*loggingT).flushDaemon(0x251bb00)
	/go/src/k8s.io/kubernetes/vendor/github.com/golang/glog/glog.go:879 +0x8b
created by k8s.io/kubernetes/vendor/github.com/golang/glog.init.0
	/go/src/k8s.io/kubernetes/vendor/github.com/golang/glog/glog.go:410 +0x272

goroutine 33 [chan receive]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil.(*MergeLogger).outputLoop(0xc0001eff60)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil/merge_logger.go:174 +0x3a2
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil.NewMergeLogger
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil/merge_logger.go:92 +0x80

goroutine 73 [chan receive]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil.(*MergeLogger).outputLoop(0xc0003ce640)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil/merge_logger.go:174 +0x3a2
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil.NewMergeLogger
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/logutil/merge_logger.go:92 +0x80

goroutine 81 [chan send]:
k8s.io/kubernetes/pkg/storage.(*cacheWatcher).sendWatchCacheEvent(0xc000348390, 0xc0003a1e08)
	/go/src/k8s.io/kubernetes/pkg/storage/cacher.go:852 +0x287
k8s.io/kubernetes/pkg/storage.(*cacheWatcher).process(0xc000348390, 0xc00036e4e0, 0x2, 0x2, 0x0)
	/go/src/k8s.io/kubernetes/pkg/storage/cacher.go:879 +0x13f
created by k8s.io/kubernetes/pkg/storage.newCacheWatcher
	/go/src/k8s.io/kubernetes/pkg/storage/cacher.go:766 +0x10f
```

