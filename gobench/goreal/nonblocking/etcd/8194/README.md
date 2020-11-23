
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[etcd#8194]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[etcd#8194]:(etcd8194_test.go)
[patch]:https://github.com/etcd-io/etcd/pull/8194/files
[pull request]:https://github.com/etcd-io/etcd/pull/8194
 

## Backtrace

```
Read at 0x0000011af650 by goroutine 17:
  _/go/src/github.com/coreos/etcd/lease.(*lessor).runLoop()
      /go/src/github.com/coreos/etcd/lease/lessor.go:474 +0x248

Previous write at 0x0000011af650 by goroutine 319:
  [failed to restore the stack]

Goroutine 17 (running) created at:
  _/go/src/github.com/coreos/etcd/lease.newLessor()
      /go/src/github.com/coreos/etcd/lease/lessor.go:168 +0x273
  _/go/src/github.com/coreos/etcd/lease.TestLessorRenewExtendPileup()
      /go/src/github.com/coreos/etcd/lease/lessor_test.go:242 +0x55f
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 319 (running) created at:
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
      _testmain.go:60 +0x223
```

