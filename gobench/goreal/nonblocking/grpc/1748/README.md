
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#1748]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[grpc#1748]:(grpc1748_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/1748/files
[pull request]:https://github.com/grpc/grpc-go/pull/1748
 

## Backtrace

```
Write at 0x000001274658 by goroutine 52:
  google.golang.org/grpc.TestCloseConnectionWhenServerPrefaceNotReceived.func1()
      /go/src/google.golang.org/grpc/clientconn_test.go:175 +0x3a
  google.golang.org/grpc.TestCloseConnectionWhenServerPrefaceNotReceived()
      /go/src/google.golang.org/grpc/clientconn_test.go:253 +0x47c
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Previous read at 0x000001274658 by goroutine 57:
  google.golang.org/grpc.(*addrConn).resetTransport()
      /go/src/google.golang.org/grpc/clientconn.go:1052 +0x3c5
  google.golang.org/grpc.(*addrConn).transportMonitor()
      /go/src/google.golang.org/grpc/clientconn.go:1251 +0x61a
  google.golang.org/grpc.(*addrConn).connect.func1()
      /go/src/google.golang.org/grpc/clientconn.go:821 +0x275

Goroutine 52 (running) created at:
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
      _testmain.go:218 +0x223

Goroutine 57 (finished) created at:
  google.golang.org/grpc.(*addrConn).connect()
      /go/src/google.golang.org/grpc/clientconn.go:812 +0x190
  google.golang.org/grpc.(*acBalancerWrapper).Connect()
      /go/src/google.golang.org/grpc/balancer_conn_wrappers.go:289 +0x92
  google.golang.org/grpc.(*pickfirstBalancer).HandleResolvedAddrs()
      /go/src/google.golang.org/grpc/pickfirst.go:62 +0x4d1
  google.golang.org/grpc.(*ccBalancerWrapper).watcher()
      /go/src/google.golang.org/grpc/balancer_conn_wrappers.go:139 +0x54d
```

