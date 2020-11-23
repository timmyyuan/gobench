
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#7901]|[pull request]|[patch]| NonBlocking | Go-Specific | Special Libraries |

[serving#7901]:(serving7901_test.go)
[patch]:https://github.com/ knative/serving/pull/7901/files
[pull request]:https://github.com/ knative/serving/pull/7901
 

## Backtrace

```
panic: Log in goroutine after TestControllerCanReconcile has completed

goroutine 47 [running]:
testing.(*common).logDepth(0xc000038700, 0xc00003a0f0, 0xec, 0x3)
	/usr/local/go/src/testing/testing.go:678 +0x57a
testing.(*common).log(...)
	/usr/local/go/src/testing/testing.go:658
testing.(*common).Logf(0xc000038700, 0x2751ad4, 0x2, 0xc0004cf590, 0x1, 0x1)
	/usr/local/go/src/testing/testing.go:693 +0x90
go.uber.org/zap/zaptest.testingWriter.Write(0x2c99d00, 0xc000038700, 0x0, 0xc000635400, 0xed, 0x400, 0xc000383260, 0xc0004cf580, 0xc000569500)
	/go/pkg/mod/go.uber.org/zap@v1.14.1/zaptest/logger.go:130 +0x120
go.uber.org/zap/zapcore.(*ioCore).Write(0xc00062b710, 0xff, 0xbfe41afc8f62c180, 0x90fd8d1, 0x3ca1560, 0x277d9ff, 0x22, 0xc00002c2d0, 0x4c, 0x1, ...)
	/go/pkg/mod/go.uber.org/zap@v1.14.1/zapcore/core.go:90 +0x1c4
go.uber.org/zap/zapcore.(*CheckedEntry).Write(0xc00034eb00, 0x0, 0x0, 0x0)
	/go/pkg/mod/go.uber.org/zap@v1.14.1/zapcore/entry.go:216 +0x1e8
go.uber.org/zap.(*SugaredLogger).log(0xc0005d8340, 0x3cc04ff, 0x2789acb, 0x29, 0xc00051dc98, 0x3, 0x3, 0x0, 0x0, 0x0)
	/go/pkg/mod/go.uber.org/zap@v1.14.1/sugar.go:234 +0x142
go.uber.org/zap.(*SugaredLogger).Debugf(...)
	/go/pkg/mod/go.uber.org/zap@v1.14.1/sugar.go:133
knative.dev/pkg/controller.(*Impl).EnqueueKeyAfter(0xc000569480, 0x275f9c3, 0xe, 0x275e406, 0xd, 0x73a9d1a0)
	/go/pkg/mod/knative.dev/pkg@v0.0.0-20200509234445-b52862b1b3ea/controller/controller.go:347 +0x2cd
knative.dev/pkg/controller.(*Impl).EnqueueAfter(0xc000569480, 0x27478e0, 0xc000629680, 0x73a9d1a0)
	/go/pkg/mod/knative.dev/pkg@v0.0.0-20200509234445-b52862b1b3ea/controller/controller.go:226 +0x308
knative.dev/pkg/controller.(*Impl).FilteredGlobalResync(0xc000569480, 0xc00062b770, 0x7fb1a06e7e10, 0xc000506a20)
	/go/pkg/mod/knative.dev/pkg@v0.0.0-20200509234445-b52862b1b3ea/controller/controller.go:480 +0x198
knative.dev/serving/pkg/reconciler/autoscaling/hpa.NewController.func1.1(0x2763947, 0x11, 0x24e74e0, 0xc000382e80)
	/go/src/github.com/knative/serving/pkg/reconciler/autoscaling/hpa/controller.go:77 +0x99
knative.dev/pkg/configmap.TypeFilter.func1.1(0x2763947, 0x11, 0x24e74e0, 0xc000382e80)
	/go/pkg/mod/knative.dev/pkg@v0.0.0-20200509234445-b52862b1b3ea/configmap/filter.go:45 +0x158
knative.dev/pkg/configmap.(*UntypedStore).OnConfigChanged.func1(0xc000626460, 0x2763947, 0x11, 0x24e74e0, 0xc000382e80)
	/go/pkg/mod/knative.dev/pkg@v0.0.0-20200509234445-b52862b1b3ea/configmap/store.go:162 +0xab
created by knative.dev/pkg/configmap.(*UntypedStore).OnConfigChanged
	/go/pkg/mod/knative.dev/pkg@v0.0.0-20200509234445-b52862b1b3ea/configmap/store.go:160 +0x552
```

