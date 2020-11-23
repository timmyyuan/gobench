
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[istio#17860]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[istio#17860]:(istio17860_test.go)
[patch]:https://github.com/istio/istio/pull/17860/files
[pull request]:https://github.com/istio/istio/pull/17860
 
## Description

See the [bug kernel](../../../../goker/blocking/istio/17860/README.md)

## Backtrace

```
goroutine 7 [select]:
go.opencensus.io/stats/view.(*worker).start(0xc0000c9b80)
    /go/pkg/mod/go.opencensus.io@v0.21.0/stats/view/worker.go:154 +0x100
created by go.opencensus.io/stats/view.init.0
    /go/pkg/mod/go.opencensus.io@v0.21.0/stats/view/worker.go:32 +0x57

 Goroutine 8 in state select, with istio.io/pkg/cache.(*ttlCache).evicter on top of the stack:
goroutine 8 [select]:
istio.io/pkg/cache.(*ttlCache).evicter(0xc0001e5300, 0x1a3185c5000)
    /go/pkg/mod/istio.io/pkg@v0.0.0-20191008025934-66d669f9a3fd/cache/ttlCache.go:121 +0x10b
created by istio.io/pkg/cache.NewTTLWithCallback
    /go/pkg/mod/istio.io/pkg@v0.0.0-20191008025934-66d669f9a3fd/cache/ttlCache.go:100 +0x137

 Goroutine 9 in state select, with istio.io/istio/pilot/pkg/model.(*JwksResolver).refresher on top of the stack:
goroutine 9 [select]:
istio.io/istio/pilot/pkg/model.(*JwksResolver).refresher(0xc0001e5400)
    /go/src/istio.io/istio/pilot/pkg/model/jwks_resolver.go:333 +0xdb
created by istio.io/istio/pilot/pkg/model.NewJwksResolver
    /go/src/istio.io/istio/pilot/pkg/model/jwks_resolver.go:174 +0x1be

 Goroutine 20 in state semacquire, with sync.runtime_SemacquireMutex on top of the stack:
goroutine 20 [semacquire]:
sync.runtime_SemacquireMutex(0xc0002f6314, 0x4fe800, 0x1)
    /usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc0002f6310)
    /usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
    /usr/local/go/src/sync/mutex.go:81
istio.io/istio/pkg/envoy.(*agent).Run(0xc0002b6550, 0x1149680, 0xc0002e46c0, 0x0, 0x0)
    /go/src/istio.io/istio/pkg/envoy/agent.go:193 +0x423
istio.io/istio/pkg/envoy.TestExitDuringWaitForLive.func3(0x1130aa0, 0xc0002b6550, 0x1149680, 0xc0002e46c0)
    /go/src/istio.io/istio/pkg/envoy/agent_test.go:197 +0x45
created by istio.io/istio/pkg/envoy.TestExitDuringWaitForLive
    /go/src/istio.io/istio/pkg/envoy/agent_test.go:197 +0x34f

 Goroutine 22 in state select, with istio.io/istio/pkg/envoy.(*agent).waitUntilLive on top of the stack:
goroutine 22 [select]:
istio.io/istio/pkg/envoy.(*agent).waitUntilLive(0xc0002b6550)
    /go/src/istio.io/istio/pkg/envoy/agent.go:175 +0x1d0
istio.io/istio/pkg/envoy.(*agent).Restart(0xc0002b6550, 0xe0f960, 0x110f080)
    /go/src/istio.io/istio/pkg/envoy/agent.go:136 +0xf4
created by istio.io/istio/pkg/envoy.TestExitDuringWaitForLive
    /go/src/istio.io/istio/pkg/envoy/agent_test.go:203 +0x3be
```

