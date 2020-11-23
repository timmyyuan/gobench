
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#3068]|[pull request]|[patch]| NonBlocking | Go-Specific | Channel Misuse |

[serving#3068]:(serving3068_test.go)
[patch]:https://github.com/ knative/serving/pull/3068/files
[pull request]:https://github.com/ knative/serving/pull/3068
 

## Backtrace

```
panic: send on closed channel

goroutine 8 [running]:
github.com/knative/serving/pkg/pool.(*impl).Go(0xc000058640, 0xc0000464c0)
	/go/src/github.com/knative/serving/pkg/pool/pool.go:79 +0x7c
github.com/knative/serving/pkg/pool.TestRacingClose.func1(0x60dca0, 0xc000058640, 0xc00001a148, 0xc00001a150)
	/go/src/github.com/knative/serving/pkg/pool/pool_test.go:35 +0x4c
created by github.com/knative/serving/pkg/pool.TestRacingClose
	/go/src/github.com/knative/serving/pkg/pool/pool_test.go:33 +0x11e
```

