
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#2371]|[pull request]|[patch]| NonBlocking | Go-Specific | Channel Misuse |

[grpc#2371]:(grpc2371_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/2371/files
[pull request]:https://github.com/grpc/grpc-go/pull/2371
 

## Backtrace

```
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0xa63a84]

goroutine 52 [running]:
google.golang.org/grpc.(*ccBalancerWrapper).handleResolvedAddrs(0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	/go/src/google.golang.org/grpc/balancer_conn_wrappers.go:182 +0x34
google.golang.org/grpc.(*ClientConn).handleServiceConfig(0xc000129200, 0xc15c36, 0x26, 0xc00019e010, 0x1)
	/go/src/google.golang.org/grpc/clientconn.go:775 +0x55e
google.golang.org/grpc.(*ccResolverWrapper).watcher(0xc00011c700)
	/go/src/google.golang.org/grpc/resolver_conn_wrapper.go:130 +0x389
created by google.golang.org/grpc.(*ccResolverWrapper).start
	/go/src/google.golang.org/grpc/resolver_conn_wrapper.go:97 +0x4d
```

