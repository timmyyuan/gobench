
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#4407]|[pull request]|[patch]| NonBlocking | Go-Specific | Special Libraries |

[cockroach#4407]:(cockroach4407_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/4407/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/4407
 

## Backtrace

```
Read by goroutine 103:
  sync.raceRead()
      /tmp/workdir/go/src/sync/race.go:37 +0x2e
  sync.(*WaitGroup).Add()
      /tmp/workdir/go/src/sync/waitgroup.go:66 +0xfa
  github.com/cockroachdb/cockroach/util/stop.(*Stopper).RunWorker()
      /go/src/github.com/cockroachdb/cockroach/util/stop/stopper.go:95 +0x43
  github.com/cockroachdb/cockroach/gossip.(*server).Gossip()
      /go/src/github.com/cockroachdb/cockroach/gossip/server.go:137 +0x637
  github.com/cockroachdb/cockroach/gossip._Gossip_Gossip_Handler()
      /go/src/github.com/cockroachdb/cockroach/gossip/gossip.pb.go:196 +0xfe
  google.golang.org/grpc.(*Server).processStreamingRPC()
      /go/src/google.golang.org/grpc/server.go:583 +0x612
  google.golang.org/grpc.(*Server).handleStream()
      /go/src/google.golang.org/grpc/server.go:658 +0x150a
  google.golang.org/grpc.(*Server).serveStreams.func1.1()
      /go/src/google.golang.org/grpc/server.go:323 +0xad

Previous write by goroutine 28:
  sync.raceWrite()
      /tmp/workdir/go/src/sync/race.go:41 +0x2e
  sync.(*WaitGroup).Wait()
      /tmp/workdir/go/src/sync/waitgroup.go:124 +0xf9
  github.com/cockroachdb/cockroach/util/stop.(*Stopper).Stop()
      /go/src/github.com/cockroachdb/cockroach/util/stop/stopper.go:223 +0x22a
  github.com/cockroachdb/cockroach/gossip.TestGossipCullNetwork()
      /go/src/github.com/cockroachdb/cockroach/gossip/gossip_test.go:147 +0x881
  testing.tRunner()
      /tmp/workdir/go/src/testing/testing.go:456 +0xdc

Goroutine 103 (running) created at:
  google.golang.org/grpc.(*Server).serveStreams.func1()
      /go/src/google.golang.org/grpc/server.go:324 +0xa7
  google.golang.org/grpc/transport.(*http2Server).operateHeaders()
      /go/src/google.golang.org/grpc/transport/http2_server.go:212 +0x17fa
  google.golang.org/grpc/transport.(*http2Server).HandleStreams()
      /go/src/google.golang.org/grpc/transport/http2_server.go:276 +0x114d
  google.golang.org/grpc.(*Server).serveStreams()
      /go/src/google.golang.org/grpc/server.go:325 +0x1dc
  google.golang.org/grpc.(*Server).serveNewHTTP2Transport()
      /go/src/google.golang.org/grpc/server.go:312 +0x54d
  google.golang.org/grpc.(*Server).handleRawConn()
      /go/src/google.golang.org/grpc/server.go:289 +0x529

Goroutine 28 (running) created at:
  testing.RunTests()
      /tmp/workdir/go/src/testing/testing.go:561 +0xaa3
  testing.(*M).Run()
      /tmp/workdir/go/src/testing/testing.go:494 +0xe4
  github.com/cockroachdb/cockroach/util/leaktest.TestMainWithLeakCheck()
      /go/src/github.com/cockroachdb/cockroach/util/leaktest/leaktest.go:37 +0x2e
  github.com/cockroachdb/cockroach/gossip_test.TestMain()
      /go/src/github.com/cockroachdb/cockroach/gossip/main_test.go:34 +0x2e
  main.main()
      github.com/cockroachdb/cockroach/gossip/_test/_testmain.go:112 +0x209
```

