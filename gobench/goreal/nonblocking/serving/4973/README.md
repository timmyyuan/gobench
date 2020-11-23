
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#4973]|[pull request]|[patch]| NonBlocking | Go-Specific | Special Libraries |

[serving#4973]:(serving4973_test.go)
[patch]:https://github.com/ knative/serving/pull/4973/files
[pull request]:https://github.com/ knative/serving/pull/4973
 

## Backtrace

```
panic: Log in goroutine after TestStats/Scale_to_two has completed

goroutine 142 [running]:
testing.(*common).logDepth(0xc0000e3a00, 0xc00051c840, 0xb2, 0x3)
	/usr/local/go/src/testing/testing.go:678 +0x57a
testing.(*common).log(...)
	/usr/local/go/src/testing/testing.go:658
testing.(*common).Logf(0xc0000e3a00, 0x2112faf, 0x2, 0xc000283760, 0x1, 0x1)
	/usr/local/go/src/testing/testing.go:693 +0x90
knative.dev/serving/vendor/go.uber.org/zap/zaptest.testingWriter.Write(0x24a1360, 0xc0000e3a00, 0x0, 0xc000522000, 0xb3, 0x400, 0xc0000add20, 0xc000283750, 0xc00043ea00)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zaptest/logger.go:130 +0x120
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*ioCore).Write(0xc00021ae70, 0x2, 0xbfe41b7a315454b8, 0xc5fb0986, 0x3285220, 0xc00011a6c0, 0x16, 0x21306db, 0x1c, 0x1, ...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/core.go:90 +0x1c4
knative.dev/serving/vendor/go.uber.org/zap/zapcore.(*CheckedEntry).Write(0xc000573970, 0xc00043ffc0, 0x1, 0x1)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/zapcore/entry.go:215 +0x1e8
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).log(0xc000226570, 0xc00044da02, 0x21306db, 0x1c, 0x0, 0x0, 0x0, 0xc00044d990, 0x1, 0x1)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:234 +0x142
knative.dev/serving/vendor/go.uber.org/zap.(*SugaredLogger).Errorw(...)
	/go/src/knative.dev/serving/vendor/go.uber.org/zap/sugar.go:191
knative.dev/serving/pkg/activator/handler.(*ConcurrencyReporter).reportToMetricsBackend(0xc000539020, 0x2114188, 0x4, 0x2114048, 0x4, 0x2)
	/go/src/knative.dev/serving/pkg/activator/handler/concurrency_reporter.go:92 +0x2ab
knative.dev/serving/pkg/activator/handler.(*ConcurrencyReporter).Run(0xc000539020, 0xc000220d80)
	/go/src/knative.dev/serving/pkg/activator/handler/concurrency_reporter.go:130 +0x8ac
knative.dev/serving/pkg/activator/handler.TestStats.func1.1(0xc000539020, 0xc000220d80)
	/go/src/knative.dev/serving/pkg/activator/handler/concurrency_reporter_test.go:205 +0x43
created by knative.dev/serving/pkg/activator/handler.TestStats.func1
	/go/src/knative.dev/serving/pkg/activator/handler/concurrency_reporter_test.go:204 +0x11a
```

