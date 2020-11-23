
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[etcd#5509]|[pull request]|[patch]| Blocking | Resource Deadlock | Double Locking |

[etcd#5509]:(etcd5509_test.go)
[patch]:https://github.com/etcd-io/etcd/pull/5509/files
[pull request]:https://github.com/etcd-io/etcd/pull/5509
 
## Description

Some description from developers or pervious reseachers

> r.acquire() returns holding r.client.mu.RLock() on success; 
> it was dead locking because it was returning with the rlock held on 
> a failure path and leaking it. After that any call to client.Close() 
> will block forever waiting for the wlock.

See its [bug kernel](../../../../goker/blocking/etcd/5509/README.md)

## Backtrace

```
goroutine 41 [chan receive]:
github.com/coreos/etcd/pkg/logutil.(*MergeLogger).outputLoop(0xc42020ca40)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/logutil/merge_logger.go:174 +0x40d
created by github.com/coreos/etcd/pkg/logutil.NewMergeLogger
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/logutil/merge_logger.go:92 +0x85

goroutine 33 [chan receive]:
github.com/coreos/etcd/pkg/logutil.(*MergeLogger).outputLoop(0xc4202c0120)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/logutil/merge_logger.go:174 +0x40d
created by github.com/coreos/etcd/pkg/logutil.NewMergeLogger
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/logutil/merge_logger.go:92 +0x85

goroutine 61 [chan receive, 9 minutes]:
github.com/coreos/etcd/clientv3.(*Client).Close(0xc4202f06e0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/client.go:117 +0x128
github.com/coreos/etcd/clientv3/integration.TestKVGetErrConnClosed(0xc4202ea0f0)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/integration/kv_test.go:300 +0x16d
testing.tRunner(0xc4202ea0f0, 0xd0e238)
	/usr/local/go/src/testing/testing.go:777 +0xd0
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:824 +0x2e0

goroutine 62 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7ff0404c7c90, 0x72, 0xc42030eb78)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc42017ce18, 0x72, 0xffffffffffffff00, 0xd68340, 0x10e2730)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc42017ce18, 0xc4202fa000, 0x8000, 0x8000)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Read(0xc42017ce00, 0xc4202fa000, 0x8000, 0x8000, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:157 +0x17d
net.(*netFD).Read(0xc42017ce00, 0xc4202fa000, 0x8000, 0x8000, 0x9, 0x0, 0x0)
	/usr/local/go/src/net/fd_unix.go:202 +0x4f
net.(*conn).Read(0xc42017a1c0, 0xc4202fa000, 0x8000, 0x8000, 0x0, 0x0, 0x0)
	/usr/local/go/src/net/net.go:176 +0x6a
bufio.(*Reader).Read(0xc42015c660, 0xc4202700f8, 0x9, 0x9, 0x30, 0x18, 0xc325c0)
	/usr/local/go/src/bufio/bufio.go:216 +0x238
io.ReadAtLeast(0xd65f00, 0xc42015c660, 0xc4202700f8, 0x9, 0x9, 0x9, 0xc42030edb0, 0x4018ee, 0xc42030ee57)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0xd65f00, 0xc42015c660, 0xc4202700f8, 0x9, 0x9, 0x767724, 0xc4201e3650, 0xc4201e0004)
	/usr/local/go/src/io/io.go:327 +0x58
golang.org/x/net/http2.readFrameHeader(0xc4202700f8, 0x9, 0x9, 0xd65f00, 0xc42015c660, 0x0, 0xc400000000, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/golang.org/x/net/http2/frame.go:236 +0x7b
golang.org/x/net/http2.(*Framer).ReadFrame(0xc4202700c0, 0xd69d00, 0xc4201e3650, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/golang.org/x/net/http2/frame.go:463 +0xa4
google.golang.org/grpc/transport.(*framer).readFrame(0xc4201b7380, 0xc4201e3650, 0xc4201e3650, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http_util.go:406 +0x2f
google.golang.org/grpc/transport.(*http2Client).reader(0xc4202ea2d0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http2_client.go:791 +0xa2
created by google.golang.org/grpc/transport.newHTTP2Client
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http2_client.go:174 +0x8b8

goroutine 63 [select, 9 minutes]:
google.golang.org/grpc/transport.(*http2Client).controller(0xc4202ea2d0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http2_client.go:869 +0x119
created by google.golang.org/grpc/transport.newHTTP2Client
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http2_client.go:201 +0xbd3

goroutine 64 [select, 9 minutes]:
google.golang.org/grpc.(*Conn).transportMonitor(0xc4202ea1e0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/clientconn.go:547 +0x126
created by google.golang.org/grpc.NewConn
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/clientconn.go:346 +0x260

goroutine 65 [semacquire, 9 minutes]:
sync.runtime_Semacquire(0xc4202f07b8)
	/usr/local/go/src/runtime/sema.go:56 +0x39
sync.(*RWMutex).Lock(0xc4202f07b0)
	/usr/local/go/src/sync/rwmutex.go:98 +0x6e
github.com/coreos/etcd/clientv3.(*Client).retryConnection(0xc4202f06e0, 0xd661a0, 0xc4200644d0, 0x0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/client.go:286 +0x54
github.com/coreos/etcd/clientv3.(*Client).connMonitor.func1(0xc4202f06e0, 0xc42030bf28)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/client.go:343 +0x4c
github.com/coreos/etcd/clientv3.(*Client).connMonitor(0xc4202f06e0)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/client.go:355 +0x396
created by github.com/coreos/etcd/clientv3.newClient
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/clientv3/client.go:259 +0x34e

goroutine 85 [select]:
github.com/coreos/etcd/mvcc/backend.(*backend).run(0xc42015cae0)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:184 +0x12f
created by github.com/coreos/etcd/mvcc/backend.newBackend
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/backend/backend.go:119 +0x241

goroutine 86 [select, 9 minutes]:
github.com/coreos/etcd/wal.(*filePipeline).run(0xc420165440)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/wal/file_pipeline.go:89 +0x139
created by github.com/coreos/etcd/wal.newFilePipeline
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/wal/file_pipeline.go:47 +0x11a

goroutine 87 [select]:
github.com/coreos/etcd/raft.(*node).run(0xc42017f630, 0xc4201b3380)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/raft/node.go:300 +0x5bc
created by github.com/coreos/etcd/raft.StartNode
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/raft/node.go:203 +0x5f2

goroutine 88 [select]:
github.com/coreos/etcd/lease.(*lessor).runLoop(0xc42017f770)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/lease/lessor.go:360 +0x164
created by github.com/coreos/etcd/lease.newLessor
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/lease/lessor.go:163 +0x13f

goroutine 89 [select, 9 minutes]:
github.com/coreos/etcd/pkg/schedule.(*fifo).run(0xc42015d140)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/schedule/schedule.go:146 +0x242
created by github.com/coreos/etcd/pkg/schedule.NewFIFOScheduler
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/schedule/schedule.go:71 +0x156

goroutine 90 [select]:
github.com/coreos/etcd/mvcc.(*watchableStore).syncWatchersLoop(0xc4202ec510)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/watchable_store.go:280 +0x1d6
created by github.com/coreos/etcd/mvcc.newWatchableStore
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/watchable_store.go:84 +0x20e

goroutine 91 [select, 9 minutes]:
github.com/coreos/etcd/mvcc.(*watchableStore).syncVictimsLoop(0xc4202ec510)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/watchable_store.go:306 +0x18c
created by github.com/coreos/etcd/mvcc.newWatchableStore
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/mvcc/watchable_store.go:85 +0x230

goroutine 92 [select]:
github.com/coreos/etcd/etcdserver.(*EtcdServer).run(0xc4201b4200)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/server.go:575 +0x452
created by github.com/coreos/etcd/etcdserver.(*EtcdServer).start
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/server.go:471 +0x271

goroutine 94 [select, 9 minutes]:
github.com/coreos/etcd/etcdserver.(*EtcdServer).purgeFile(0xc4201b4200)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/server.go:482 +0x166
created by github.com/coreos/etcd/etcdserver.(*EtcdServer).Start
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/server.go:448 +0x8f

goroutine 95 [select]:
github.com/coreos/etcd/etcdserver.monitorFileDescriptor(0xc4202df2c0)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/metrics.go:95 +0x17e
created by github.com/coreos/etcd/etcdserver.(*EtcdServer).Start
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/server.go:449 +0xb8

goroutine 96 [select]:
github.com/coreos/etcd/etcdserver.(*EtcdServer).monitorVersions(0xc4201b4200)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/server.go:1198 +0x159
created by github.com/coreos/etcd/etcdserver.(*EtcdServer).Start
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/server.go:450 +0xda

goroutine 97 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7ff0404c7f00, 0x72, 0x0)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc42017c698, 0x72, 0xc420208500, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc42017c698, 0xffffffffffffff00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Accept(0xc42017c680, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:372 +0x1a8
net.(*netFD).accept(0xc42017c680, 0x412358, 0x30, 0xc40180)
	/usr/local/go/src/net/fd_unix.go:238 +0x42
net.(*TCPListener).accept(0xc42017a1a8, 0x51c42a, 0xc40180, 0xc420200a20)
	/usr/local/go/src/net/tcpsock_posix.go:136 +0x2e
net.(*TCPListener).Accept(0xc42017a1a8, 0xc420034090, 0xba20e0, 0x11131e0, 0xcbd3e0)
	/usr/local/go/src/net/tcpsock.go:259 +0x49
net/http.(*Server).Serve(0xc4201b3790, 0xd6e120, 0xc42017a1a8, 0x0, 0x0)
	/usr/local/go/src/net/http/server.go:2773 +0x1a5
net/http/httptest.(*Server).goServe.func1(0xc420275810)
	/usr/local/go/src/net/http/httptest/server.go:280 +0x6d
created by net/http/httptest.(*Server).goServe
	/usr/local/go/src/net/http/httptest/server.go:278 +0x5c

goroutine 102 [select]:
github.com/coreos/etcd/etcdserver/api.runCapabilityLoop(0xc4201b4200)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/api/capability.go:78 +0x12c
github.com/coreos/etcd/etcdserver/api.RunCapabilityLoop.func1()
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/api/capability.go:60 +0x2a
sync.(*Once).Do(0x1147818, 0xc420163710)
	/usr/local/go/src/sync/once.go:44 +0xbe
created by github.com/coreos/etcd/etcdserver/api.RunCapabilityLoop
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/api/capability.go:60 +0x80

goroutine 11 [select]:
github.com/coreos/etcd/etcdserver.(*raftNode).start.func1(0xc4201b4218)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/raft.go:151 +0x220
created by github.com/coreos/etcd/etcdserver.(*raftNode).start
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/raft.go:144 +0x195

goroutine 12 [select]:
github.com/coreos/etcd/pkg/schedule.(*fifo).run(0xc420082780)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/schedule/schedule.go:146 +0x242
created by github.com/coreos/etcd/pkg/schedule.NewFIFOScheduler
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/pkg/schedule/schedule.go:71 +0x156

goroutine 103 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7ff0404c7e30, 0x72, 0x0)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc42017c818, 0x72, 0xc42016d700, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc42017c818, 0xffffffffffffff00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Accept(0xc42017c800, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:372 +0x1a8
net.(*netFD).accept(0xc42017c800, 0x461737, 0xc4202ae940, 0xb99200)
	/usr/local/go/src/net/fd_unix.go:238 +0x42
net.(*TCPListener).accept(0xc42017a1b0, 0x457ca0, 0xc4204b1ef0, 0xc4204b1ef8)
	/usr/local/go/src/net/tcpsock_posix.go:136 +0x2e
net.(*TCPListener).Accept(0xc42017a1b0, 0xd10800, 0xc4202ae8c0, 0xd6f5a0, 0xc4201b9a10)
	/usr/local/go/src/net/tcpsock.go:259 +0x49
net/http.(*Server).Serve(0xc4201b3860, 0xd6e120, 0xc42017a1b0, 0x0, 0x0)
	/usr/local/go/src/net/http/server.go:2773 +0x1a5
net/http/httptest.(*Server).goServe.func1(0xc420275c00)
	/usr/local/go/src/net/http/httptest/server.go:280 +0x6d
created by net/http/httptest.(*Server).goServe
	/usr/local/go/src/net/http/httptest/server.go:278 +0x5c

goroutine 104 [select]:
github.com/coreos/etcd/etcdserver/api/v3rpc.monitorLeader.func1(0xc4201b4200, 0xc420163750)
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/api/v3rpc/interceptor.go:147 +0x120
created by github.com/coreos/etcd/etcdserver/api/v3rpc.monitorLeader
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/api/v3rpc/interceptor.go:142 +0x87

goroutine 105 [semacquire, 9 minutes]:
sync.runtime_SemacquireMutex(0x114781c, 0x0)
	/usr/local/go/src/runtime/sema.go:71 +0x3d
sync.(*Mutex).Lock(0x1147818)
	/usr/local/go/src/sync/mutex.go:134 +0x108
sync.(*Once).Do(0x1147818, 0xc4201638b0)
	/usr/local/go/src/sync/once.go:40 +0x44
created by github.com/coreos/etcd/etcdserver/api.RunCapabilityLoop
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/etcdserver/api/capability.go:60 +0x80

goroutine 106 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7ff0404c7d60, 0x72, 0x0)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc42017ca98, 0x72, 0xc420208600, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc42017ca98, 0xffffffffffffff00, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Accept(0xc42017ca80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:372 +0x1a8
net.(*netFD).accept(0xc42017ca80, 0xc42020e0b0, 0x0, 0x0)
	/usr/local/go/src/net/fd_unix.go:238 +0x42
net.(*UnixListener).accept(0xc4201b7290, 0x457ca0, 0xc42049df50, 0xc42049df58)
	/usr/local/go/src/net/unixsock_posix.go:162 +0x32
net.(*UnixListener).Accept(0xc4201b7290, 0xd103b8, 0xc4202ec7e0, 0xd736a0, 0xc42020e0b0)
	/usr/local/go/src/net/unixsock.go:253 +0x49
google.golang.org/grpc.(*Server).Serve(0xc4202ec7e0, 0xd6e160, 0xc4201b7290, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/server.go:277 +0x161
created by github.com/coreos/etcd/integration.(*member).Launch
	/go/src/github.com/coreos/etcd/gopath/src/github.com/coreos/etcd/integration/cluster.go:623 +0x8b9

goroutine 114 [IO wait, 9 minutes]:
internal/poll.runtime_pollWait(0x7ff0404c7bc0, 0x72, 0xc42049e998)
	/usr/local/go/src/runtime/netpoll.go:173 +0x57
internal/poll.(*pollDesc).wait(0xc420210418, 0x72, 0xffffffffffffff00, 0xd68340, 0x10e2730)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:85 +0x9b
internal/poll.(*pollDesc).waitRead(0xc420210418, 0xc4204b6000, 0x8000, 0x8000)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:90 +0x3d
internal/poll.(*FD).Read(0xc420210400, 0xc4204b6000, 0x8000, 0x8000, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:157 +0x17d
net.(*netFD).Read(0xc420210400, 0xc4204b6000, 0x8000, 0x8000, 0x1a, 0x0, 0x0)
	/usr/local/go/src/net/fd_unix.go:202 +0x4f
net.(*conn).Read(0xc42020e0b0, 0xc4204b6000, 0x8000, 0x8000, 0x0, 0x0, 0x0)
	/usr/local/go/src/net/net.go:176 +0x6a
bufio.(*Reader).Read(0xc420219080, 0xc42024e1b8, 0x9, 0x9, 0xc420180720, 0x10, 0x0)
	/usr/local/go/src/bufio/bufio.go:216 +0x238
io.ReadAtLeast(0xd65f00, 0xc420219080, 0xc42024e1b8, 0x9, 0x9, 0x9, 0xc42049ebf8, 0x4058bc, 0x582349)
	/usr/local/go/src/io/io.go:309 +0x86
io.ReadFull(0xd65f00, 0xc420219080, 0xc42024e1b8, 0x9, 0x9, 0xc4201a2418, 0xc42049ec98, 0x582724)
	/usr/local/go/src/io/io.go:327 +0x58
golang.org/x/net/http2.readFrameHeader(0xc42024e1b8, 0x9, 0x9, 0xd65f00, 0xc420219080, 0x0, 0x0, 0xc42049eca8, 0xc42049ec98)
	/go/src/github.com/coreos/etcd/gopath/src/golang.org/x/net/http2/frame.go:236 +0x7b
golang.org/x/net/http2.(*Framer).ReadFrame(0xc42024e180, 0xc4203220e0, 0xc420180720, 0xc4203220e0, 0x1)
	/go/src/github.com/coreos/etcd/gopath/src/golang.org/x/net/http2/frame.go:463 +0xa4
google.golang.org/grpc/transport.(*framer).readFrame(0xc4201b9a40, 0xc420180720, 0xc420180720, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http_util.go:406 +0x2f
google.golang.org/grpc/transport.(*http2Server).HandleStreams(0xc42032cc60, 0xc4201b9ad0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http2_server.go:243 +0x268
google.golang.org/grpc.(*Server).serveStreams(0xc4202ec7e0, 0xd72440, 0xc42032cc60)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/server.go:344 +0x129
google.golang.org/grpc.(*Server).serveNewHTTP2Transport(0xc4202ec7e0, 0xd736a0, 0xc42020e0b0, 0x0, 0x0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/server.go:337 +0x36c
google.golang.org/grpc.(*Server).handleRawConn(0xc4202ec7e0, 0xd736a0, 0xc42020e0b0)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/server.go:314 +0x3fe
created by google.golang.org/grpc.(*Server).Serve
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/server.go:286 +0x14a

goroutine 77 [select, 9 minutes]:
google.golang.org/grpc/transport.(*http2Server).controller(0xc42032cc60)
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http2_server.go:652 +0x119
created by google.golang.org/grpc/transport.newHTTP2Server
	/go/src/github.com/coreos/etcd/gopath/src/google.golang.org/grpc/transport/http2_server.go:134 +0x532
```

