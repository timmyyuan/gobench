
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[etcd#4876]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[etcd#4876]:(etcd4876_test.go)
[patch]:https://github.com/etcd-io/etcd/pull/4876/files
[pull request]:https://github.com/etcd-io/etcd/pull/4876
 

## Backtrace

```
Write by goroutine 215:
  github.com/coreos/etcd/clientv3.(*kv).switchRemote()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/kv.go:194 +0x158

Previous read by goroutine 199:
  github.com/coreos/etcd/clientv3.(*kv).switchRemote()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/kv.go:186 +0x63
  github.com/coreos/etcd/clientv3.(*kv).Do()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/kv.go:179 +0x490
  github.com/coreos/etcd/clientv3.(*kv).Get()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/kv.go:103 +0xdb
  github.com/coreos/etcd/clientv3/integration.TestKVPutFailGetRetry.func1()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/integration/kv_test.go:441 +0xa1

Goroutine 215 (running) created at:
  github.com/coreos/etcd/clientv3.(*kv).Do()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/kv.go:175 +0x41e
  github.com/coreos/etcd/clientv3.(*kv).Put()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/kv.go:98 +0xf5
  github.com/coreos/etcd/clientv3/integration.TestKVPutFailGetRetry()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/integration/kv_test.go:433 +0x4c0
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:473 +0xdc

Goroutine 199 (running) created at:
  github.com/coreos/etcd/clientv3/integration.TestKVPutFailGetRetry()
      /go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/integration/kv_test.go:449 +0x5a6
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:473 +0xdc
```

