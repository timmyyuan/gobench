
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#49404]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#49404]:(kubernetes49404_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/49404/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/49404
 

## Backtrace

```
Read at 0x00c0002d8852 by goroutine 87:
  k8s.io/kube-aggregator/pkg/apiserver.TestProxyUpgrade.func1.2()
      /go/src/k8s.io/kube-aggregator/pkg/apiserver/handler_proxy_test.go:327 +0x50
  k8s.io/kube-aggregator/pkg/apiserver.TestProxyUpgrade.func1()
      /go/src/k8s.io/kube-aggregator/pkg/apiserver/handler_proxy_test.go:370 +0x1045
  k8s.io/kube-aggregator/pkg/apiserver.TestProxyUpgrade()
      /go/src/k8s.io/kube-aggregator/pkg/apiserver/handler_proxy_test.go:370 +0xb13
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Previous write at 0x00c0002d8852 by goroutine 21:
  k8s.io/kube-aggregator/pkg/apiserver.TestProxyUpgrade.func1.1()
      /go/src/k8s.io/kube-aggregator/pkg/apiserver/handler_proxy_test.go:313 +0x193
  golang.org/x/net/websocket.Server.serveWebSocket()
      /go/src/golang.org/x/net/websocket/server.go:89 +0x232
  golang.org/x/net/websocket.Handler.ServeHTTP()
      /go/src/golang.org/x/net/websocket/server.go:112 +0x93
  net/http.(*ServeMux).ServeHTTP()
      /usr/local/go/src/net/http/server.go:2416 +0x288
  net/http.serverHandler.ServeHTTP()
      /usr/local/go/src/net/http/server.go:2831 +0xce
  net/http.(*conn).serve()
      /usr/local/go/src/net/http/server.go:1919 +0x837

Goroutine 87 (running) created at:
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

Goroutine 21 (running) created at:
  net/http.(*Server).Serve()
      /usr/local/go/src/net/http/server.go:2957 +0x5b5
  net/http/httptest.(*Server).goServe.func1()
      /usr/local/go/src/net/http/httptest/server.go:298 +0xb6
```

