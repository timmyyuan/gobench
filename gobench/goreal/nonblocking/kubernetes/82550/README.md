
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#82550]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#82550]:(kubernetes82550_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/82550/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/82550
 

## Backtrace

```
Write at 0x00c00015e1a0 by goroutine 11:
  k8s.io/kubernetes/pkg/credentialprovider/aws.(*lazyEcrProvider).LazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:126 +0x42d

Previous read at 0x00c00015e1a0 by goroutine 10:
  k8s.io/kubernetes/pkg/credentialprovider/aws.(*lazyEcrProvider).LazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:124 +0x5e

Goroutine 11 (running) created at:
  k8s.io/kubernetes/pkg/credentialprovider/aws.TestConcurrentEcrLazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials_test.go:175 +0x130
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 10 (running) created at:
  k8s.io/kubernetes/pkg/credentialprovider/aws.TestConcurrentEcrLazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials_test.go:175 +0x130
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

```
Write at 0x00c0001c0038 by goroutine 19:
  sync/atomic.CompareAndSwapInt32()
      /usr/local/go/src/runtime/race_amd64.s:293 +0xb
  sync.(*Mutex).Lock()
      /usr/local/go/src/sync/mutex.go:74 +0x49
  k8s.io/kubernetes/pkg/credentialprovider.(*CachingDockerConfigProvider).Provide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/provider.go:108 +0x6a
  k8s.io/kubernetes/pkg/credentialprovider/aws.(*lazyEcrProvider).LazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:135 +0xb4

Previous write at 0x00c0001c0038 by goroutine 10:
  k8s.io/kubernetes/pkg/credentialprovider/aws.(*lazyEcrProvider).LazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:129 +0x3aa

Goroutine 19 (running) created at:
  k8s.io/kubernetes/pkg/credentialprovider/aws.TestConcurrentEcrLazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials_test.go:175 +0x130
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 10 (running) created at:
  k8s.io/kubernetes/pkg/credentialprovider/aws.TestConcurrentEcrLazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials_test.go:175 +0x130
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

```
Read at 0x00c0001c0020 by goroutine 19:
  k8s.io/kubernetes/pkg/credentialprovider.(*CachingDockerConfigProvider).Provide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/provider.go:112 +0xef
  k8s.io/kubernetes/pkg/credentialprovider/aws.(*lazyEcrProvider).LazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:135 +0xb4

Previous write at 0x00c0001c0020 by goroutine 10:
  k8s.io/kubernetes/pkg/credentialprovider/aws.(*lazyEcrProvider).LazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:129 +0x3aa

Goroutine 19 (running) created at:
  k8s.io/kubernetes/pkg/credentialprovider/aws.TestConcurrentEcrLazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials_test.go:175 +0x130
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 10 (running) created at:
  k8s.io/kubernetes/pkg/credentialprovider/aws.TestConcurrentEcrLazyProvide()
      /go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials_test.go:175 +0x130
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

```
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x18 pc=0x941234]

goroutine 44 [running]:
k8s.io/kubernetes/pkg/credentialprovider/aws.(*ecrProvider).Provide(0xc0001be000, 0x18)
	/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:192 +0xc4
k8s.io/kubernetes/pkg/credentialprovider.(*CachingDockerConfigProvider).Provide(0xc0001c0000, 0x0)
	/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/provider.go:117 +0x22e
k8s.io/kubernetes/pkg/credentialprovider/aws.(*lazyEcrProvider).LazyProvide(0xc00015e180, 0x21)
	/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials.go:135 +0xb5
created by k8s.io/kubernetes/pkg/credentialprovider/aws.TestConcurrentEcrLazyProvide
	/go/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/credentialprovider/aws/aws_credentials_test.go:175 +0x131
```