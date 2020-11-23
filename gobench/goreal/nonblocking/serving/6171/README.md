
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#6171]|[pull request]|[patch]| NonBlocking | Go-Specific | Special Libraries |

[serving#6171]:(serving6171_test.go)
[patch]:https://github.com/ knative/serving/pull/6171/files
[pull request]:https://github.com/ knative/serving/pull/6171
 

## Backtrace

```
panic: Log in goroutine after TestServiceMoreThanOne has completed

goroutine 28 [running]:
testing.(*common).logDepth(0xc000562100, 0xc0006960a0, 0x9c, 0x3)
	/usr/local/go/src/testing/testing.go:678 +0x57a
testing.(*common).log(...)
	/usr/local/go/src/testing/testing.go:658
testing.(*common).Logf(0xc000562100, 0x249ba36, 0x2, 0xc000506200, 0x1, 0x1)
	/usr/local/go/src/testing/testing.go:693 +0x90
knative.dev/serving/vendor/go.uber.org/zap/zaptest.testingWriter.Write(0x288f560, 0xc000562100, 0x0, 0xc000694000, 0x9d, 0x400, 0xc0005deb60, 0xc0005061f0, 0xc000510300)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zaptest/logger.go:130 +0x120
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*ioCore).Write(0xc000504120, 0x2, 0xbfe41cebe2a6265e, 0x37c3cb92, 0x3827da0, 0x0, 0x0, 0x24a82cd, 0xe, 0x1, ...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/core.go:90 +0x1c4
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*CheckedEntry).Write(0xc00058a0b0, 0xc000510100, 0x1, 0x1)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/entry.go:215 +0x1e8
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).log(0xc00056c000, 0xc0004a3c02, 0x24a82cd, 0xe, 0x0, 0x0, 0x0, 0xc0004a3b58, 0x1, 0x1)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:234 +0x142
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).Errorw(...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:191
knative.dev/serving/pkg/activator/net.(*revisionWatcher).checkDests(0xc000568320, 0xc0005051a0)
	/go/src/knative.dev/serving/pkg/activator/net/revision_backends.go:251 +0xe82
knative.dev/serving/pkg/activator/net.(*revisionWatcher).run(0xc000568320, 0xbebc200)
	/go/src/knative.dev/serving/pkg/activator/net/revision_backends.go:326 +0x116
created by knative.dev/serving/pkg/activator/net.(*revisionBackendsManager).getOrCreateRevisionWatcher
	/go/src/knative.dev/serving/pkg/activator/net/revision_backends.go:425 +0x4b2
```

