
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#6472]|[pull request]|[patch]| NonBlocking | Traditional | Order Violation |

[serving#6472]:(serving6472_test.go)
[patch]:https://github.com/ knative/serving/pull/6472/files
[pull request]:https://github.com/ knative/serving/pull/6472
 

## Backtrace

```
Write at 0x00c0003f0958 by goroutine 30:
  sync/atomic.AddInt32()
      /usr/local/go/src/runtime/race_amd64.s:269 +0xb
  knative.dev/serving/pkg/network/status.(*Prober).updateStates()
      /go/src/knative.dev/serving/pkg/network/status/status.go:417 +0x98
  knative.dev/serving/pkg/network/status.(*Prober).processWorkItem()
      /go/src/knative.dev/serving/pkg/network/status/status.go:406 +0xb3f
  knative.dev/serving/pkg/network/status.(*Prober).Start.func1()
      /go/src/knative.dev/serving/pkg/network/status/status.go:282 +0x6c

Previous write at 0x00c0003f0958 by goroutine 44:
  knative.dev/serving/pkg/network/status.(*Prober).IsReady()
      /go/src/knative.dev/serving/pkg/network/status/status.go:264 +0x1264
  knative.dev/serving/pkg/network/status.TestPartialPodCancellation()
      /go/src/knative.dev/serving/pkg/network/status/status_test.go:418 +0xae0
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 30 (running) created at:
  knative.dev/serving/pkg/network/status.(*Prober).Start()
      /go/src/knative.dev/serving/pkg/network/status/status.go:280 +0xb5
  knative.dev/serving/pkg/network/status.TestPartialPodCancellation()
      /go/src/knative.dev/serving/pkg/network/status/status_test.go:412 +0xa4a
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 44 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:960 +0x651
  testing.runTests.func1()
      /usr/local/go/src/testing/testing.go:1202 +0xa6
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
  testing.runTests()
      /usr/local/go/src/testing/testing.go:1200 +0x521
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:1117 +0x2ff
  main.main()
      _testmain.go:52 +0x223
```

