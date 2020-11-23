
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#4908]|[pull request]|[patch]| NonBlocking | Go-Specific | Special Libraries |

[serving#4908]:(serving4908_test.go)
[patch]:https://github.com/ knative/serving/pull/4908/files
[pull request]:https://github.com/ knative/serving/pull/4908
 

## Backtrace

```
panic: Log in goroutine after TestRevisionWatcher/single_error_dest has completed

goroutine 49 [running]:
testing.(*common).logDepth(0xc000311200, 0xc000461180, 0x246, 0x3)
	/usr/local/go/src/testing/testing.go:678 +0x57a
testing.(*common).log(...)
	/usr/local/go/src/testing/testing.go:658
testing.(*common).Logf(0xc000311200, 0x20e65ef, 0x2, 0xc00054a200, 0x1, 0x1)
	/usr/local/go/src/testing/testing.go:693 +0x90
knative.dev/serving/vendor/go.uber.org/zap/zaptest.testingWriter.Write(0x246d3c0, 0xc000311200, 0x200, 0xc0000e5000, 0x247, 0x400, 0xc000122a80, 0xc00054a190, 0xc00034a680)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zaptest/logger.go:130 +0x120
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*ioCore).Write(0xc0005477a0, 0x2, 0xbfe41ab1fa99c43e, 0x8f3f697, 0x323da20, 0xc0000b8120, 0x25, 0xc000042240, 0x1d, 0x1, ...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/core.go:90 +0x1c4
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*CheckedEntry).Write(0xc00051cc60, 0xc00034a840, 0x1, 0x1)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/entry.go:215 +0x1e8
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).log(0xc0005c6068, 0xc00006ae02, 0xc000042240, 0x1d, 0x0, 0x0, 0x0, 0xc00006ae30, 0x1, 0x1)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:234 +0x142
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).Errorw(...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:191
knative.dev/serving/pkg/activator.(*revisionWatcher).checkDests.func1(0x245b9e0, 0xc000378300, 0xc000456540, 0xc0003782a0, 0x20f21c1, 0xe)
	/go/src/knative.dev/serving/pkg/activator/revision_backends.go:133 +0x5e1
created by knative.dev/serving/pkg/activator.(*revisionWatcher).checkDests
	/go/src/knative.dev/serving/pkg/activator/revision_backends.go:121 +0x2aa
```

