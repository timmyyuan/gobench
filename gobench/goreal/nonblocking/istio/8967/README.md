
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[istio#8967]|[pull request]|[patch]| NonBlocking | Go-Specific | Channel Misuse |

[istio#8967]:(istio8967_test.go)
[patch]:https://github.com/istio/istio/pull/8967/files
[pull request]:https://github.com/istio/istio/pull/8967
 

## Backtrace

```
Read at 0x00c0000bfb70 by goroutine 10:
  istio.io/istio/galley/pkg/fs.(*fsSource).Start.func1()
      /go/src/istio.io/istio/galley/pkg/fs/fssource.go:291 +0xb6

Previous write at 0x00c0000bfb70 by goroutine 7:
  istio.io/istio/galley/pkg/fs.(*fsSource).Stop()
      /go/src/istio.io/istio/galley/pkg/fs/fssource.go:214 +0xe3
  istio.io/istio/galley/pkg/fs.TestFsSource_InitialScan()
      /go/src/istio.io/istio/galley/pkg/fs/fssource_test.go:195 +0x591
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 10 (running) created at:
  istio.io/istio/galley/pkg/fs.(*fsSource).Start()
      /go/src/istio.io/istio/galley/pkg/fs/fssource.go:248 +0x151
  istio.io/istio/galley/pkg/fs.TestFsSource_InitialScan()
      /go/src/istio.io/istio/galley/pkg/fs/fssource_test.go:183 +0x3bb
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 7 (running) created at:
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
      _testmain.go:54 +0x223
```

