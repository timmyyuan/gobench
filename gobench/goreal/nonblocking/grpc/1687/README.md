
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#1687]|[pull request]|[patch]| NonBlocking | Go-Specific | Channel Misuse |

[grpc#1687]:(grpc1687_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/1687/files
[pull request]:https://github.com/grpc/grpc-go/pull/1687
 

## Backtrace

```
panic: send on closed channel

goroutine 22 [running]:
google.golang.org/grpc/transport.(*serverHandlerTransport).do(0xc0000965b0, 0xc00016c000, 0x0, 0x0)
	/go/src/google.golang.org/grpc/transport/handler_server.go:170 +0x171
google.golang.org/grpc/transport.(*serverHandlerTransport).Write(0xc0000965b0, 0xc0000d0a00, 0xc00016a000, 0x3, 0x3, 0xc00016a004, 0x4, 0x4, 0xc00016a008, 0x0, ...)
	/go/src/google.golang.org/grpc/transport/handler_server.go:256 +0x187
google.golang.org/grpc/transport.TestHandlerTransport_HandleStreams_WriteStatusWrite.func1(0xc000089710, 0xc0000d0a00)
	/go/src/google.golang.org/grpc/transport/handler_server_test.go:425 +0x431
created by google.golang.org/grpc/transport.testHandlerTransportHandleStreams.func1
	/go/src/google.golang.org/grpc/transport/handler_server_test.go:432 +0x5d
```

