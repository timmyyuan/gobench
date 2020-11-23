
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#649]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[grpc#649]:(grpc649_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/649/files
[pull request]:https://github.com/grpc/grpc-go/pull/649
 
## Description

Some description from developers or pervious reseachers

> fixes a goroutine leak in that case.

This bug is because the developer did not close the channel `t.errorChan`

## Backtrace

```
google.golang.org/grpc.NewClientStream.func1(0xabec80, 0xc000386000, 0xc0004a2380, 0xc0004a4500)
    /go/src/google.golang.org/grpc/stream.go:151 +0xde
created by google.golang.org/grpc.NewClientStream
    /go/src/google.golang.org/grpc/stream.go:150 +0x2dc
end2end_test.go:1931: Leaked goroutine: goroutine 30 [select]:
google.golang.org/grpc.NewClientStream.func1(0xabec80, 0xc0003860f0, 0xc0003a00e0, 0xc0000b7b80)
    /go/src/google.golang.org/grpc/stream.go:151 +0xde
created by google.golang.org/grpc.NewClientStream
    /go/src/google.golang.org/grpc/stream.go:150 +0x2dc
end2end_test.go:1931: Leaked goroutine: goroutine 57 [select]:
google.golang.org/grpc.NewClientStream.func1(0xabec80, 0xc0004282d0, 0xc00040c2a0, 0xc0000b65a0)
    /go/src/google.golang.org/grpc/stream.go:151 +0xde
created by google.golang.org/grpc.NewClientStream
    /go/src/google.golang.org/grpc/stream.go:150 +0x2dc
end2end_test.go:1931: Leaked goroutine: goroutine 63 [select]:
google.golang.org/grpc.NewClientStream.func1(0xabec80, 0xc0004284b0, 0xc00040c620, 0xc0000b7ea0)
    /go/src/google.golang.org/grpc/stream.go:151 +0xde
created by google.golang.org/grpc.NewClientStream
    /go/src/google.golang.org/grpc/stream.go:150 +0x2dc
```

