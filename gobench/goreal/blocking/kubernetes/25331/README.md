
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#25331]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel & Context |

[kubernetes#25331]:(kubernetes25331_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/25331/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/25331
 
## Description

Some description from developers or pervious reseachers

> In reflector.go, it could probably call Stop() without retrieving all results
  from ResultChan(). See [here]. A potential leak is that when an error has happened, it could block on resultChan,
  and then cancelling context in Stop() wouldn't unblock it.

[here]:https://github.com/kubernetes/kubernetes/blob/master/pkg/client/cache/reflector.go#L369

See the [bug kernel](../../../../goker/blocking/kubernetes/25331/README.md)

## Backtrace

```
goroutine 43 [semacquire, 9 minutes]:
sync.runtime_Semacquire(0xc420174efc)
	/usr/local/go/src/runtime/sema.go:56 +0x39
sync.(*WaitGroup).Wait(0xc420174ef0)
	/usr/local/go/src/sync/waitgroup.go:129 +0x72
k8s.io/kubernetes/pkg/storage/etcd3.TestWatchErrResultNotBlockAfterCancel(0xc4203da2d0)
	/go/src/k8s.io/kubernetes/pkg/storage/etcd3/watcher_test.go:213 +0x257
testing.tRunner(0xc4203da2d0, 0x13aad20)
	/usr/local/go/src/testing/testing.go:777 +0xd0
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:824 +0x2e0

goroutine 44 [select, 9 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*http2Client).controller(0xc4203da3c0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http2_client.go:827 +0x119
created by k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.newHTTP2Client
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http2_client.go:194 +0xc17

goroutine 45 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7f37db585c90, 0x72, 0xc42005ac40)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc4203e2b98, 0x72, 0xffffffffffffff00, 0x1434560, 0x1c84118)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc4203e2b98, 0xc420218e00, 0x9, 0x9)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Read(0xc4203e2b80, 0xc420218e34, 0x9, 0x9, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:157 +0x17d
net.(*netFD).Read(0xc4203e2b80, 0xc420218e34, 0x9, 0x9, 0x9, 0x0, 0x0)
	/usr/local/go/src/net/fd_unix.go:202 +0x4f
net.(*conn).Read(0xc42000e1b0, 0xc420218e34, 0x9, 0x9, 0x0, 0x0, 0x0)
	/usr/local/go/src/net/net.go:176 +0x6a
io.ReadAtLeast(0x7f37db50d9d0, 0xc42000e1b0, 0xc420218e34, 0x9, 0x9, 0x9, 0xc420218e28, 0xc4202fc0f0, 0x1)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0x7f37db50d9d0, 0xc42000e1b0, 0xc420218e34, 0x9, 0x9, 0x6, 0x0, 0xaa)
	/usr/local/go/src/io/io.go:327 +0x58
k8s.io/kubernetes/vendor/golang.org/x/net/http2.readFrameHeader(0xc420218e34, 0x9, 0x9, 0x7f37db50d9d0, 0xc42000e1b0, 0x0, 0xc400000000, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/golang.org/x/net/http2/frame.go:228 +0x7b
k8s.io/kubernetes/vendor/golang.org/x/net/http2.(*Framer).ReadFrame(0xc420218e10, 0x1436940, 0xc4202fc0f0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/golang.org/x/net/http2/frame.go:373 +0x86
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*framer).readFrame(0xc4201924b0, 0xc4202fc0f0, 0xc4202fc0f0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http_util.go:453 +0x2f
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*http2Client).reader(0xc4203da3c0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http2_client.go:757 +0xc6
created by k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.newHTTP2Client
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http2_client.go:200 +0xc5d

goroutine 46 [select, 10 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Conn).transportMonitor(0xc420224000)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/clientconn.go:511 +0x126
created by k8s.io/kubernetes/vendor/google.golang.org/grpc.NewConn
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/clientconn.go:313 +0x249

goroutine 47 [select, 10 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*recvBufferReader).Read(0xc420436060, 0xc42017a570, 0x5, 0x5, 0x0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:141 +0x278
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*Stream).Read(0xc42043a000, 0xc42017a570, 0x5, 0x5, 0x5, 0xc42017a570, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:294 +0x56
io.ReadAtLeast(0x1432f20, 0xc42043a000, 0xc42017a570, 0x5, 0x5, 0x5, 0x114e6e0, 0x1, 0xc42017a570)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0x1432f20, 0xc42043a000, 0xc42017a570, 0x5, 0x5, 0xc420254640, 0x1360a7a, 0xc42005be18)
	/usr/local/go/src/io/io.go:327 +0x58
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*parser).recvMsg(0xc420164490, 0x82d5fd, 0xc4202409a8, 0x13ad830, 0xc4202409a8, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:206 +0x72
k8s.io/kubernetes/vendor/google.golang.org/grpc.recv(0xc420164490, 0x1440d80, 0x1cd9a28, 0xc42043a000, 0x0, 0x0, 0x1273aa0, 0xc4201e71c0, 0x123bc20, 0x82ca01)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:288 +0x40
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*clientStream).RecvMsg(0xc4202a20a0, 0x1273aa0, 0xc4201e71c0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:228 +0x7f
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb.(*leaseLeaseKeepAliveClient).Recv(0xc4201644b0, 0x14472a0, 0xc4201644b0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb/rpc.pb.go:2030 +0x62
k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.(*lessor).recvKeepAliveLoop(0xc4202409a0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/lease.go:262 +0x98
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.NewLease
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/lease.go:101 +0x186

goroutine 48 [select, 10 minutes]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.(*watcher).run(0xc4203e2d80)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/watch.go:297 +0x2c6
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.NewWatcher
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/watch.go:162 +0x279

goroutine 116 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7f37db585e30, 0x72, 0x0)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc4203e2598, 0x72, 0xc42007ca00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc4203e2598, 0xffffffffffffff00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Accept(0xc4203e2580, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:372 +0x1a8
net.(*netFD).accept(0xc4203e2580, 0x401d77, 0xc4201ef520, 0x1185da0)
	/usr/local/go/src/net/fd_unix.go:238 +0x42
net.(*TCPListener).accept(0xc42000e1a0, 0x4582e0, 0xc4202aeef0, 0xc4202aeef8)
	/usr/local/go/src/net/tcpsock_posix.go:136 +0x2e
net.(*TCPListener).Accept(0xc42000e1a0, 0x13ad0d0, 0xc4201ef4a0, 0x14420c0, 0xc420013230)
	/usr/local/go/src/net/tcpsock.go:259 +0x49
net/http.(*Server).Serve(0xc42026ab60, 0x143fe40, 0xc42000e1a0, 0x0, 0x0)
	/usr/local/go/src/net/http/server.go:2773 +0x1a5
net/http/httptest.(*Server).goServe.func1(0xc420228540)
	/usr/local/go/src/net/http/httptest/server.go:280 +0x6d
created by net/http/httptest.(*Server).goServe
	/usr/local/go/src/net/http/httptest/server.go:278 +0x5c

goroutine 79 [select, 10 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc.NewClientStream.func1(0x1443bc0, 0xc4203da3c0, 0xc420348000, 0xc420350000)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:148 +0xff
created by k8s.io/kubernetes/vendor/google.golang.org/grpc.NewClientStream
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:147 +0x2fb

goroutine 32 [select, 10 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc.NewClientStream.func1(0x1443bc0, 0xc4203da3c0, 0xc42043a000, 0xc4202a20a0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:148 +0xff
created by k8s.io/kubernetes/vendor/google.golang.org/grpc.NewClientStream
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:147 +0x2fb

goroutine 33 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.(*lessor).sendKeepAliveLoop(0xc4202409a0, 0x14472a0, 0xc4201644b0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/lease.go:317 +0x310
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.(*lessor).resetRecv
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/lease.go:280 +0xb0

goroutine 80 [select, 10 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*recvBufferReader).Read(0xc4201bd680, 0xc4203620d0, 0x5, 0x5, 0x0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:141 +0x278
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*Stream).Read(0xc420348000, 0xc4203620d0, 0x5, 0x5, 0x5, 0xc4203620d0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:294 +0x56
io.ReadAtLeast(0x1432f20, 0xc420348000, 0xc4203620d0, 0x5, 0x5, 0x5, 0x114e6e0, 0x1, 0xc4203620d0)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0x1432f20, 0xc420348000, 0xc4203620d0, 0x5, 0x5, 0x0, 0x0, 0x0)
	/usr/local/go/src/io/io.go:327 +0x58
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*parser).recvMsg(0xc4202a41c0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:206 +0x72
k8s.io/kubernetes/vendor/google.golang.org/grpc.recv(0xc4202a41c0, 0x1440d80, 0x1cd9a28, 0xc420348000, 0x0, 0x0, 0x127c140, 0xc420386100, 0x128d640, 0x1)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:288 +0x40
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*clientStream).RecvMsg(0xc420350000, 0x127c140, 0xc420386100, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:228 +0x7f
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb.(*watchWatchClient).Recv(0xc4202a41d0, 0x0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb/rpc.pb.go:1905 +0x62
k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.(*watcher).serveWatchClient(0xc4203e2d80, 0x1447300, 0xc4202a41d0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/watch.go:390 +0x4e
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3.(*watcher).newWatchClient
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/clientv3/watch.go:486 +0x9a

goroutine 98 [select, 10 minutes]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/wal.(*filePipeline).run(0xc42015ac40)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/wal/file_pipeline.go:87 +0x139
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/wal.newFilePipeline
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/wal/file_pipeline.go:47 +0x11a

goroutine 99 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/raft.(*node).run(0xc42016d950, 0xc4200a3d40)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/raft/node.go:300 +0x5c1
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/raft.StartNode
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/raft/node.go:203 +0x5f2

goroutine 100 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage/backend.(*backend).run(0xc420097200)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage/backend/backend.go:182 +0x12f
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage/backend.newBackend
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage/backend/backend.go:117 +0x235

goroutine 101 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/lease.(*lessor).runLoop(0xc42016dae0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/lease/lessor.go:360 +0x164
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/lease.newLessor
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/lease/lessor.go:163 +0x13f

goroutine 102 [select, 10 minutes]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule.(*fifo).run(0xc4200972c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule/schedule.go:146 +0x242
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule.NewFIFOScheduler
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule/schedule.go:71 +0x156

goroutine 103 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage.(*watchableStore).syncWatchersLoop(0xc4202416c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage/watchable_store.go:237 +0x145
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage.newWatchableStore
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/storage/watchable_store.go:77 +0x1db

goroutine 104 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*EtcdServer).run(0xc4202732c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/server.go:545 +0x43c
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*EtcdServer).start
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/server.go:447 +0x271

goroutine 215 [chan send, 9 minutes]:
k8s.io/kubernetes/pkg/storage/etcd3.(*watchChan).run(0xc4204e42a0)
	/go/src/k8s.io/kubernetes/pkg/storage/etcd3/watcher.go:116 +0x215
k8s.io/kubernetes/pkg/storage/etcd3.TestWatchErrResultNotBlockAfterCancel.func1(0xc4204e42a0, 0xc420174ef0)
	/go/src/k8s.io/kubernetes/pkg/storage/etcd3/watcher_test.go:208 +0x2b
created by k8s.io/kubernetes/pkg/storage/etcd3.TestWatchErrResultNotBlockAfterCancel
	/go/src/k8s.io/kubernetes/pkg/storage/etcd3/watcher_test.go:207 +0x1e2

goroutine 106 [select, 9 minutes]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*EtcdServer).purgeFile(0xc4202732c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/server.go:458 +0x16c
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*EtcdServer).Start
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/server.go:424 +0x92

goroutine 107 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.monitorFileDescriptor(0xc420039260)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/metrics.go:81 +0x1ad
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*EtcdServer).Start
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/server.go:425 +0xbb

goroutine 108 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*EtcdServer).monitorVersions(0xc4202732c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/server.go:1248 +0x159
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*EtcdServer).Start
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/server.go:426 +0xdd

goroutine 109 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7f37db585f00, 0x72, 0x0)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc4203e2298, 0x72, 0xc42007ca00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc4203e2298, 0xffffffffffffff00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Accept(0xc4203e2280, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:372 +0x1a8
net.(*netFD).accept(0xc4203e2280, 0x412998, 0x30, 0x127d560)
	/usr/local/go/src/net/fd_unix.go:238 +0x42
net.(*TCPListener).accept(0xc42000e198, 0x51d83a, 0x127d560, 0xc420012e70)
	/usr/local/go/src/net/tcpsock_posix.go:136 +0x2e
net.(*TCPListener).Accept(0xc42000e198, 0xc420034090, 0x1194de0, 0x1c72db0, 0x131d4c0)
	/usr/local/go/src/net/tcpsock.go:259 +0x49
net/http.(*Server).Serve(0xc42001a410, 0x143fe40, 0xc42000e198, 0x0, 0x0)
	/usr/local/go/src/net/http/server.go:2773 +0x1a5
net/http/httptest.(*Server).goServe.func1(0xc420241b90)
	/usr/local/go/src/net/http/httptest/server.go:280 +0x6d
created by net/http/httptest.(*Server).goServe
	/usr/local/go/src/net/http/httptest/server.go:278 +0x5c

goroutine 110 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v2http.capabilityLoop(0xc4202732c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v2http/capability.go:69 +0x20f
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v2http.NewClientHandler
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v2http/client.go:65 +0x54

goroutine 81 [runnable]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*raftNode).start.func1(0xc4202732c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/raft.go:152 +0x220
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver.(*raftNode).start
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/raft.go:145 +0x198

goroutine 114 [select]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule.(*fifo).run(0xc4204e4ae0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule/schedule.go:146 +0x242
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule.NewFIFOScheduler
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/pkg/schedule/schedule.go:71 +0x156

goroutine 117 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7f37db585d60, 0x72, 0x0)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc4203e2818, 0x72, 0xc42007c600, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc4203e2818, 0xffffffffffffff00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Accept(0xc4203e2800, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:372 +0x1a8
net.(*netFD).accept(0xc4203e2800, 0xc42000e348, 0x0, 0x0)
	/usr/local/go/src/net/fd_unix.go:238 +0x42
net.(*UnixListener).accept(0xc4201bff20, 0x4582e0, 0xc420060f08, 0xc420060f10)
	/usr/local/go/src/net/unixsock_posix.go:162 +0x32
net.(*UnixListener).Accept(0xc4201bff20, 0x13acdd0, 0xc420188080, 0x1447660, 0xc42000e348)
	/usr/local/go/src/net/unixsock.go:253 +0x49
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).Serve(0xc420188080, 0x143fe80, 0xc4201bff20, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:239 +0x165
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/integration.(*member).Launch
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/integration/cluster.go:594 +0x7e6

goroutine 111 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7f37db585bc0, 0x72, 0xc420061a90)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc4203e3418, 0x72, 0xffffffffffffff00, 0x1434560, 0x1c84118)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc4203e3418, 0xc420219600, 0x9, 0x9)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Read(0xc4203e3400, 0xc420219614, 0x9, 0x9, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:157 +0x17d
net.(*netFD).Read(0xc4203e3400, 0xc420219614, 0x9, 0x9, 0x4, 0x0, 0x0)
	/usr/local/go/src/net/fd_unix.go:202 +0x4f
net.(*conn).Read(0xc42000e348, 0xc420219614, 0x9, 0x9, 0x0, 0x0, 0x0)
	/usr/local/go/src/net/net.go:176 +0x6a
io.ReadAtLeast(0x7f37db50d9d0, 0xc42000e348, 0xc420219614, 0x9, 0x9, 0x9, 0xc420061ce0, 0x57eda4, 0x1442600)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0x7f37db50d9d0, 0xc42000e348, 0xc420219614, 0x9, 0x9, 0x0, 0x0, 0x0)
	/usr/local/go/src/io/io.go:327 +0x58
k8s.io/kubernetes/vendor/golang.org/x/net/http2.readFrameHeader(0xc420219614, 0x9, 0x9, 0x7f37db50d9d0, 0xc42000e348, 0x0, 0xc400000000, 0x1430c40, 0xc4200624b0)
	/go/src/k8s.io/kubernetes/vendor/golang.org/x/net/http2/frame.go:228 +0x7b
k8s.io/kubernetes/vendor/golang.org/x/net/http2.(*Framer).ReadFrame(0xc4202195f0, 0xc420348460, 0xc4203326d0, 0xc420348460, 0x1)
	/go/src/k8s.io/kubernetes/vendor/golang.org/x/net/http2/frame.go:373 +0x86
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*framer).readFrame(0xc420013260, 0xc4203326d0, 0xc4203326d0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http_util.go:453 +0x2f
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*http2Server).HandleStreams(0xc420219680, 0xc4200132f0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http2_server.go:249 +0x413
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).serveStreams(0xc420188080, 0x1445380, 0xc420219680)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:292 +0x119
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).serveNewHTTP2Transport(0xc420188080, 0x1447660, 0xc42000e348, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:285 +0x348
created by k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).Serve
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:267 +0x26e

goroutine 112 [select, 9 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*http2Server).controller(0xc420219680)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http2_server.go:626 +0x119
created by k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.newHTTP2Server
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/http2_server.go:134 +0x532

goroutine 113 [select, 9 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*recvBufferReader).Read(0xc420013440, 0xc420174298, 0x5, 0x5, 0x0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:141 +0x278
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*Stream).Read(0xc4202247e0, 0xc420174298, 0x5, 0x5, 0x5, 0x165, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:294 +0x56
io.ReadAtLeast(0x1432f20, 0xc4202247e0, 0xc420174298, 0x5, 0x5, 0x5, 0x114e6e0, 0x101, 0xc420174298)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0x1432f20, 0xc4202247e0, 0xc420174298, 0x5, 0x5, 0x1cf, 0xc4000001d1, 0x86)
	/usr/local/go/src/io/io.go:327 +0x58
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*parser).recvMsg(0xc4203e4010, 0x13ad788, 0xc42004f3a0, 0xc42004f3e8, 0x45b944, 0x42be10, 0xc42004f3a0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:206 +0x72
k8s.io/kubernetes/vendor/google.golang.org/grpc.recv(0xc4203e4010, 0x1440d80, 0x1cd9a28, 0xc4202247e0, 0x0, 0x0, 0x1260dc0, 0xc420174290, 0xbfc7d3002cca5501, 0xc420174290)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:288 +0x40
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*serverStream).RecvMsg(0xc420176080, 0x1260dc0, 0xc420174290, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:401 +0xc0
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb.(*leaseLeaseKeepAliveServer).Recv(0xc4203e4020, 0x0, 0xc420274000, 0xc42011a054)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb/rpc.pb.go:2098 +0x62
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc.(*LeaseServer).LeaseKeepAlive(0xc4202a4330, 0x1446820, 0xc4203e4020, 0x1, 0xc4203e4020)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc/lease.go:53 +0x35
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb._Lease_LeaseKeepAlive_Handler(0x11ee580, 0xc420386300, 0x1443b40, 0xc420176080, 0xc420036a94, 0xe)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb/rpc.pb.go:2079 +0xb2
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).processStreamingRPC(0xc420188080, 0x1445380, 0xc420219680, 0xc4202247e0, 0xc4204e2900, 0x1c75c20, 0xc420012150, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:503 +0x1b6
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).handleStream(0xc420188080, 0x1445380, 0xc420219680, 0xc4202247e0, 0xc420012150)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:578 +0xfeb
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).serveStreams.func1.1(0xc420175480, 0xc420188080, 0x1445380, 0xc420219680, 0xc4202247e0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:296 +0x9f
created by k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).serveStreams.func1
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:294 +0xa1

goroutine 130 [select, 9 minutes]:
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*recvBufferReader).Read(0xc420013530, 0xc4203621c0, 0x5, 0x5, 0x0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:141 +0x278
k8s.io/kubernetes/vendor/google.golang.org/grpc/transport.(*Stream).Read(0xc4202248c0, 0xc4203621c0, 0x5, 0x5, 0x5, 0xc4203621c0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/transport/transport.go:294 +0x56
io.ReadAtLeast(0x1432f20, 0xc4202248c0, 0xc4203621c0, 0x5, 0x5, 0x5, 0x114e6e0, 0x1, 0xc4203621c0)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0x1432f20, 0xc4202248c0, 0xc4203621c0, 0x5, 0x5, 0x45b944, 0xc4202a9ca8, 0xc4204e65a0)
	/usr/local/go/src/io/io.go:327 +0x58
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*parser).recvMsg(0xc4203e5a30, 0x45b944, 0xc4204e65b8, 0x13acdf8, 0x1, 0xc4204e65a0, 0x13acdf8)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:206 +0x72
k8s.io/kubernetes/vendor/google.golang.org/grpc.recv(0xc4203e5a30, 0x1440d80, 0x1cd9a28, 0xc4202248c0, 0x0, 0x0, 0x1291b40, 0xc4202a4520, 0xc42025d001, 0xc4202a4520)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/rpc_util.go:288 +0x40
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*serverStream).RecvMsg(0xc4203e3500, 0x1291b40, 0xc4202a4520, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/stream.go:401 +0xc0
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb.(*watchWatchServer).Recv(0xc4203e5a40, 0x13aaf28, 0x1, 0xc42025d0c0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb/rpc.pb.go:1945 +0x62
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc.(*serverWatchStream).recvLoop(0xc420097aa0, 0x13aaf30, 0xc420097aa0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc/watch.go:116 +0x49
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc.(*watchServer).Watch(0xc4201bdbc0, 0x1446880, 0xc4203e5a40, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc/watch.go:111 +0x1ec
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb._Watch_Watch_Handler(0x1191cc0, 0xc4201bdbc0, 0x1443b40, 0xc4203e3500, 0xc4203d9934, 0x5)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/etcdserverpb/rpc.pb.go:1926 +0xb2
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).processStreamingRPC(0xc420188080, 0x1445380, 0xc420219680, 0xc4202248c0, 0xc4204e28e0, 0x1c75c00, 0xc4200135c0, 0x0, 0x0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:503 +0x1b6
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).handleStream(0xc420188080, 0x1445380, 0xc420219680, 0xc4202248c0, 0xc4200135c0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:578 +0xfeb
k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).serveStreams.func1.1(0xc420175480, 0xc420188080, 0x1445380, 0xc420219680, 0xc4202248c0)
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:296 +0x9f
created by k8s.io/kubernetes/vendor/google.golang.org/grpc.(*Server).serveStreams.func1
	/go/src/k8s.io/kubernetes/vendor/google.golang.org/grpc/server.go:294 +0xa1

goroutine 120 [select, 9 minutes]:
k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc.(*serverWatchStream).sendLoop(0xc420097aa0)
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc/watch.go:187 +0x4db
created by k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc.(*watchServer).Watch
	/go/src/k8s.io/kubernetes/vendor/github.com/coreos/etcd/etcdserver/api/v3rpc/watch.go:110 +0x1de
```

