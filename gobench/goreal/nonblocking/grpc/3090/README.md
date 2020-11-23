
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#3090]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[grpc#3090]:(grpc3090_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/3090/files
[pull request]:https://github.com/grpc/grpc-go/pull/3090
 

## Backtrace

```
Read at 0x00c000212f08 by goroutine 28:
  google.golang.org/grpc.(*ccResolverWrapper).resolveNow()
      /go/src/google.golang.org/grpc/resolver_conn_wrapper.go:106 +0xa3
  google.golang.org/grpc.(*ccResolverWrapper).poll.func1()
      /go/src/google.golang.org/grpc/resolver_conn_wrapper.go:141 +0x62

Previous write at 0x00c000212f08 by goroutine 27:
  google.golang.org/grpc.newCCResolverWrapper()
      /go/src/google.golang.org/grpc/resolver_conn_wrapper.go:96 +0x330
  google.golang.org/grpc.DialContext()
      /go/src/google.golang.org/grpc/clientconn.go:299 +0xf24
  google.golang.org/grpc.TestResolverErrorInBuild()
      /go/src/google.golang.org/grpc/clientconn.go:105 +0x344
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 28 (running) created at:
  google.golang.org/grpc.(*ccResolverWrapper).poll()
      /go/src/google.golang.org/grpc/resolver_conn_wrapper.go:139 +0x21d
  google.golang.org/grpc.(*ccResolverWrapper).UpdateState()
      /go/src/google.golang.org/grpc/resolver_conn_wrapper.go:172 +0x2a8
  google.golang.org/grpc/resolver/manual.(*Resolver).Build()
      /go/src/google.golang.org/grpc/resolver/manual/manual.go:82 +0x16a
  google.golang.org/grpc.newCCResolverWrapper()
      /go/src/google.golang.org/grpc/resolver_conn_wrapper.go:96 +0x2e7
  google.golang.org/grpc.DialContext()
      /go/src/google.golang.org/grpc/clientconn.go:299 +0xf24
  google.golang.org/grpc.TestResolverErrorInBuild()
      /go/src/google.golang.org/grpc/clientconn.go:105 +0x344
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 27 (running) created at:
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
      _testmain.go:70 +0x223
```

