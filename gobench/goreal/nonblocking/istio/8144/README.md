
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[istio#8144]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[istio#8144]:(istio8144_test.go)
[patch]:https://github.com/istio/istio/pull/8144/files
[pull request]:https://github.com/istio/istio/pull/8144
 

## Backtrace

```
panic: Log in goroutine after TestServerInst_Close has completed

goroutine 50 [running]:
testing.(*common).logDepth(0xc00032a400, 0xc0000a0690, 0x24, 0x3)
	/usr/local/go/src/testing/testing.go:678 +0x57a
testing.(*common).log(...)
	/usr/local/go/src/testing/testing.go:658
testing.(*common).Log(0xc00032a400, 0xc00006de80, 0x1, 0x1)
	/usr/local/go/src/testing/testing.go:686 +0x78
istio.io/istio/mixer/pkg/adapter/test.(*Env).log(0xc000379da0, 0x1e94540, 0x20, 0xc0001e0240, 0x1, 0x1, 0x5faff301, 0xc0001e0240)
	/go/src/istio.io/istio/mixer/pkg/adapter/test/env.go:117 +0x221
istio.io/istio/mixer/pkg/adapter/test.(*Env).Infof(0xc000379da0, 0x1e94540, 0x20, 0xc0001e0240, 0x1, 0x1)
	/go/src/istio.io/istio/mixer/pkg/adapter/test/env.go:62 +0x6b
istio.io/istio/mixer/adapter/prometheus.(*serverInst).Start.func1()
	/go/src/istio.io/istio/mixer/adapter/prometheus/server.go:106 +0x172
istio.io/istio/mixer/pkg/adapter/test.(*Env).ScheduleDaemon.func1(0xc000371f00, 0xc000379da0)
	/go/src/istio.io/istio/mixer/pkg/adapter/test/env.go:55 +0x35
created by istio.io/istio/mixer/pkg/adapter/test.(*Env).ScheduleDaemon
	/go/src/istio.io/istio/mixer/pkg/adapter/test/env.go:54 +0x57
```

