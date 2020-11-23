
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#7513]|[pull request]|[patch]| NonBlocking | Go-Specific | Special Libraries |

[serving#7513]:(serving7513_test.go)
[patch]:https://github.com/ knative/serving/pull/7513/files
[pull request]:https://github.com/ knative/serving/pull/7513
 

## Backtrace

```
panic: Log in goroutine after TestUpdateDomainConfigMap/example.com has completed

goroutine 2228 [running]:
testing.(*common).logDepth(0xc000577000, 0xc0013f0380, 0xd5, 0x3)
	/usr/local/go/src/testing/testing.go:678 +0x57a
testing.(*common).log(...)
	/usr/local/go/src/testing/testing.go:658
testing.(*common).Logf(0xc000577000, 0x27e8734, 0x2, 0xc000358780, 0x1, 0x1)
	/usr/local/go/src/testing/testing.go:693 +0x90
knative.dev/serving/vendor/go.uber.org/zap/zaptest.testingWriter.Write(0x2dbf7a0, 0xc000577000, 0x0, 0xc000e76400, 0xd6, 0x400, 0xc000e0bd60, 0xc000358770, 0xc000d0a6c0)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zaptest/logger.go:130 +0x120
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*ioCore).Write(0xc000e717d0, 0xff, 0xbfe41bb5d581c1ca, 0x1475f783e, 0x3f34580, 0x27f93d6, 0x10, 0xc000ef64e0, 0x59, 0x1, ...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/core.go:90 +0x1c4
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*CheckedEntry).Write(0xc000e6e0b0, 0x0, 0x0, 0x0)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/entry.go:215 +0x1e8
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).log(0xc0004c1960, 0x3f533ff, 0x281f181, 0x29, 0xc000b4dc70, 0x3, 0x3, 0x0, 0x0, 0x0)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:234 +0x142
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).Debugf(...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:133
knative.dev/serving/vendor/knative.dev/pkg/controller.(*Impl).EnqueueKeyAfter(0xc0011c5d80, 0x27e9969, 0x4, 0xc00052bce0, 0x24, 0x72fec783)
	/go/src/knative.dev/serving/vendor/knative.dev/pkg/controller/controller.go:319 +0x2cd
knative.dev/serving/vendor/knative.dev/pkg/controller.(*Impl).EnqueueAfter(0xc0011c5d80, 0x27bdce0, 0xc000da1800, 0x72fec783)
	/go/src/knative.dev/serving/vendor/knative.dev/pkg/controller/controller.go:208 +0x308
knative.dev/serving/vendor/knative.dev/pkg/controller.(*Impl).FilteredGlobalResync(0xc0011c5d80, 0x28a5ee0, 0x7f37c41e6028, 0xc00099f5f0)
	/go/src/knative.dev/serving/vendor/knative.dev/pkg/controller/controller.go:440 +0x198
knative.dev/serving/vendor/knative.dev/pkg/controller.(*Impl).GlobalResync(0xc0011c5d80, 0x7f37c41e6028, 0xc00099f5f0)
	/go/src/knative.dev/serving/vendor/knative.dev/pkg/controller/controller.go:427 +0x59
knative.dev/serving/pkg/reconciler/route.newControllerWithClock.func1.1(0x27f4a02, 0xd, 0x25a95c0, 0xc0004c1b18)
	/go/src/knative.dev/serving/pkg/reconciler/route/controller.go:90 +0x86
knative.dev/serving/vendor/knative.dev/pkg/configmap.TypeFilter.func1.1(0x27f4a02, 0xd, 0x25a95c0, 0xc0004c1b18)
	/go/src/knative.dev/serving/vendor/knative.dev/pkg/configmap/filter.go:45 +0x158
knative.dev/serving/vendor/knative.dev/pkg/configmap.(*UntypedStore).OnConfigChanged.func1(0xc001058500, 0x27f4a02, 0xd, 0x25a95c0, 0xc0004c1b18)
	/go/src/knative.dev/serving/vendor/knative.dev/pkg/configmap/store.go:162 +0xab
created by knative.dev/serving/vendor/knative.dev/pkg/configmap.(*UntypedStore).OnConfigChanged
	/go/src/knative.dev/serving/vendor/knative.dev/pkg/configmap/store.go:160 +0x552
```

