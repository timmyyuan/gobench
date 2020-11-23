
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#80284]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#80284]:(kubernetes80284_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/80284/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/80284
 

## Backtrace

```
Write at 0x00c00010d510 by goroutine 10:
  k8s.io/client-go/plugin/pkg/client/auth/exec.(*Authenticator).UpdateTransportConfig()
      /go/src/k8s.io/client-go/plugin/pkg/client/auth/exec/exec.go:194 +0x4ac
  k8s.io/client-go/plugin/pkg/client/auth/exec.TestConcurrentUpdateTransportConfig.func3()
      /go/src/k8s.io/client-go/plugin/pkg/client/auth/exec/exec_test.go:748 +0xaa

Previous write at 0x00c00010d510 by goroutine 11:
  k8s.io/client-go/plugin/pkg/client/auth/exec.(*Authenticator).UpdateTransportConfig()
      /go/src/k8s.io/client-go/plugin/pkg/client/auth/exec/exec.go:194 +0x4ac
  k8s.io/client-go/plugin/pkg/client/auth/exec.TestConcurrentUpdateTransportConfig.func3()
      /go/src/k8s.io/client-go/plugin/pkg/client/auth/exec/exec_test.go:748 +0xaa

Goroutine 10 (running) created at:
  k8s.io/client-go/plugin/pkg/client/auth/exec.TestConcurrentUpdateTransportConfig()
      /go/src/k8s.io/client-go/plugin/pkg/client/auth/exec/exec_test.go:745 +0x4c8
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 11 (running) created at:
  k8s.io/client-go/plugin/pkg/client/auth/exec.TestConcurrentUpdateTransportConfig()
      /go/src/k8s.io/client-go/plugin/pkg/client/auth/exec/exec_test.go:745 +0x4c8
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

