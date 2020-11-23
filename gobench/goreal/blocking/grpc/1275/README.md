
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#1275]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[grpc#1275]:(grpc1275_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/1275/files
[pull request]:https://github.com/grpc/grpc-go/pull/1275
 
## Description

The developer has a very detailed [description] of this bug.

[description]:(https://github.com/grpc/grpc-go/pull/1275#issue-123610469)

See the [bug kernel](../../../../goker/blocking/grpc/1275/README.md)

## Backtrace

```
goroutine 37 [select]:
google.golang.org/grpc/transport.(*recvBufferReader).Read(0xc0001d0040, 0xc000204000, 0xffff, 0xffff, 0x0, 0x0, 0x0)
	/go/src/google.golang.org/grpc/transport/transport.go:128 +0x289
google.golang.org/grpc/transport.(*transportReader).Read(0xc0001a6270, 0xc000204000, 0xffff, 0xffff, 0xc0001ee0c0, 0xc0001dee80, 0x80c52c)
	/go/src/google.golang.org/grpc/transport/transport.go:340 +0x55
io.ReadAtLeast(0x9acfc0, 0xc0001a6270, 0xc000204000, 0xffff, 0xffff, 0xffff, 0x860f20, 0x1, 0xc000204000)
	/usr/local/go/src/io/io.go:310 +0x87
io.ReadFull(...)
	/usr/local/go/src/io/io.go:329
google.golang.org/grpc/transport.(*Stream).Read(0xc0001ee000, 0xc000204000, 0xffff, 0xffff, 0x0, 0x0, 0x0)
	/go/src/google.golang.org/grpc/transport/transport.go:324 +0xc7
google.golang.org/grpc/transport.TestInflightStreamClosing.func1(0xc00019c3c0, 0xc0001ee000, 0xc000000000, 0x91ab76, 0x1c, 0xc000136100)
	/go/src/google.golang.org/grpc/transport/transport_test.go:402 +0xb5
created by google.golang.org/grpc/transport.TestInflightStreamClosing
	/go/src/google.golang.org/grpc/transport/transport_test.go:400 +0x2ac
```

