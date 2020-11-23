
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#795]|[pull request]|[patch]| Blocking | Resource Deadlock | Double Locking |

[grpc#795]:(grpc795_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/795/files
[pull request]:https://github.com/grpc/grpc-go/pull/795
 
## Description

This bug is because the developer forget unlock the mutex before 
a function return.

See the [bug kernel](../../../../goker/blocking/grpc/795/README.md)

## Backtrace

```
goroutine 7 [semacquire]:
sync.runtime_SemacquireMutex(0xc0000a7a9c, 0xc00009e800, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc0000a7a98)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
	/usr/local/go/src/sync/mutex.go:81
google.golang.org/grpc.(*Server).GracefulStop(0xc0000a7a40)
	/go/src/google.golang.org/grpc/server.go:801 +0x2d0
google.golang.org/grpc/test_test.testServerGracefulStopIdempotent(0xc000134100, 0xa0c828, 0x9, 0xa07f9f, 0x3, 0x0, 0x0, 0x0)
	/go/src/google.golang.org/grpc/test/end2end_test.go:573 +0x159
google.golang.org/grpc/test_test.TestServerGracefulStopIdempotent(0xc000134100)
	/go/src/google.golang.org/grpc/test/end2end_test.go:562 +0x1ae
testing.tRunner(0xc000134100, 0xa2ff98)
	/usr/local/go/src/testing/testing.go:909 +0xc9
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x350

goroutine 9 [semacquire]:
sync.runtime_SemacquireMutex(0xc0000a7a9c, 0xacef00, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc0000a7a98)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
	/usr/local/go/src/sync/mutex.go:81
google.golang.org/grpc.(*Server).Serve(0xc0000a7a40, 0xacdd80, 0xc00000e720, 0x0, 0x0)
	/go/src/google.golang.org/grpc/server.go:318 +0x42c
created by google.golang.org/grpc/test_test.(*test).startServer
	/go/src/google.golang.org/grpc/test/end2end_test.go:467 +0x3d5
```

