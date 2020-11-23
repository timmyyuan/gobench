
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#30479]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[cockroach#30479]:(cockroach30479_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/30479/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/30479
 
## Description

Some description from developers or pervious reseachers

> The test could deadlock if the callback fired during shutdown due to a
  send on an unbuffered channel. Haven't been able to get this to fail
  after this commit.


## Backtrace

```
goroutine 160863 [select]:
github.com/cockroachdb/cockroach/pkg/storage/closedts/transport.(*Server).Get(0xc003a6d0c0, 0x7fd39a86b210, 0xc0038ca790, 0x7fd39a86b210, 0xc0038ca790)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/closedts/transport/server.go:86 +0x2dd
github.com/cockroachdb/cockroach/pkg/storage/closedts/container.delayedServer.Get(0x1, 0x2b109e0, 0xc003a6d0c0, 0x2b8a9c0, 0xc0038ca790, 0x1, 0xc0038ca790)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/closedts/container/container.go:101 +0x101
github.com/cockroachdb/cockroach/pkg/storage/closedts/ctpb._ClosedTimestamp_Get_Handler(0x22def00, 0xc000402c80, 0x2b800a0, 0xc000dbb3f0, 0x616408, 0x20)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/closedts/ctpb/entry.pb.go:154 +0xad
github.com/cockroachdb/cockroach/pkg/rpc.NewServerWithInterceptor.func2(0x22def00, 0xc000402c80, 0x2b800a0, 0xc000dbb3f0, 0xc002803b60, 0x26fb3f8, 0x2b64e20, 0xc00123f2c0)
	/go/src/github.com/cockroachdb/cockroach/pkg/rpc/context.go:185 +0x100
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.(*Server).processStreamingRPC(0xc000750e00, 0x2b956a0, 0xc00323ce00, 0xc001b16200, 0xc0035ca570, 0x3c877e0, 0x0, 0x0, 0x0)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/server.go:1167 +0x41c
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.(*Server).handleStream(0xc000750e00, 0x2b956a0, 0xc00323ce00, 0xc001b16200, 0x0)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/server.go:1253 +0x123d
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.(*Server).serveStreams.func1.1(0xc000312360, 0xc000750e00, 0x2b956a0, 0xc00323ce00, 0xc001b16200)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/server.go:680 +0xbb
created by github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.(*Server).serveStreams.func1
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/server.go:678 +0xa1

goroutine 160491 [select]:
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.(*recvBufferReader).read(0xc001393310, 0xc004111e10, 0x5, 0x5, 0xb, 0xc, 0xc004111e80)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/transport.go:142 +0x1c3
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.(*recvBufferReader).Read(0xc001393310, 0xc004111e10, 0x5, 0x5, 0xc00026cb48, 0x8, 0xc0007c7aa0)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/transport.go:131 +0x5a
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.(*transportReader).Read(0xc002bc92f0, 0xc004111e10, 0x5, 0x5, 0x50, 0xc0007c7ac8, 0xb757bc)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/transport.go:394 +0x55
io.ReadAtLeast(0x2b116a0, 0xc002bc92f0, 0xc004111e10, 0x5, 0x5, 0x5, 0xffffffffffffffff, 0x0, 0xc00210d748)
	/usr/local/go/src/io/io.go:310 +0x87
io.ReadFull(...)
	/usr/local/go/src/io/io.go:329
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.(*Stream).Read(0xc001158e00, 0xc004111e10, 0x5, 0x5, 0x0, 0xc002e0a000, 0x203000)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/transport.go:378 +0xc7
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.(*parser).recvMsg(0xc004111e00, 0x7fffffff, 0xc000000001, 0xc0026af9f8, 0x58, 0x58, 0xc002090cc0, 0x0)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/rpc_util.go:452 +0x63
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.recv(0xc004111e00, 0x7fd39a8962a0, 0x3f498d0, 0xc001158e00, 0x0, 0x0, 0x24498a0, 0xc00331c3c0, 0x7fffffff, 0xc002090cc0, ...)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/rpc_util.go:578 +0x4d
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.(*csAttempt).recvMsg(0xc000507ba0, 0x24498a0, 0xc00331c3c0, 0x0, 0x0)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/stream.go:539 +0x141
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc.(*clientStream).RecvMsg(0xc000b4dd80, 0x24498a0, 0xc00331c3c0, 0x0, 0x0)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/stream.go:405 +0x43
github.com/cockroachdb/cockroach/pkg/gossip.(*gossipGossipClient).Recv(0xc002cb4730, 0x2b64e20, 0xc002bc9410, 0xc002117080)
	/go/src/github.com/cockroachdb/cockroach/pkg/gossip/gossip.pb.go:276 +0x62
github.com/cockroachdb/cockroach/pkg/gossip.(*client).gossip.func2.1(0x2b8a300, 0xc002cb4730, 0xc004493040, 0x2b64e20, 0xc002bc9410, 0xc002117080, 0xb56e54, 0xc00407fc20)
	/go/src/github.com/cockroachdb/cockroach/pkg/gossip/client.go:323 +0x3b
github.com/cockroachdb/cockroach/pkg/gossip.(*client).gossip.func2(0x2b64e20, 0xc002bc9410)
	/go/src/github.com/cockroachdb/cockroach/pkg/gossip/client.go:335 +0xea
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc002cb47b0, 0xc0030605a0, 0xc001c92d00)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:199 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:192 +0xa8

goroutine 160758 [sync.Cond.Wait]:
runtime.goparkunlock(...)
	/usr/local/go/src/runtime/proc.go:310
sync.runtime_notifyListWait(0xc0021b5ad0, 0x9)
	/usr/local/go/src/runtime/sema.go:510 +0xf8
sync.(*Cond).Wait(0xc0021b5ac0)
	/usr/local/go/src/sync/cond.go:56 +0x9d
github.com/cockroachdb/cockroach/pkg/storage.(*raftScheduler).worker(0xc003230880, 0x2b64e20, 0xc0027daa20)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/scheduler.go:196 +0xaa
github.com/cockroachdb/cockroach/pkg/storage.(*raftScheduler).Start.func2(0x2b64e20, 0xc0027daa20)
	/go/src/github.com/cockroachdb/cockroach/pkg/storage/scheduler.go:165 +0x3e
github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker.func1(0xc000265f90, 0xc003393050, 0xc000265f80)
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:199 +0x13e
created by github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunWorker
	/go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:192 +0xa8


goroutine 160556 [select]:
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.(*controlBuffer).get(0xc0041d0440, 0x1, 0x0, 0x0, 0x0, 0x0)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/controlbuf.go:293 +0x11a
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.(*loopyWriter).run(0xc001f9d0e0, 0xc000265350, 0xc0041d0440)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/controlbuf.go:370 +0x173
github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.newHTTP2Server.func2(0xc002fa2a00)
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/http2_server.go:276 +0xcb
created by github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport.newHTTP2Server
	/go/src/github.com/cockroachdb/cockroach/vendor/google.golang.org/grpc/transport/http2_server.go:273 +0xe4f

...
```

