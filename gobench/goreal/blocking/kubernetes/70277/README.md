
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#70277]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[kubernetes#70277]:(kubernetes70277_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/70277/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/70277
 
## Description

Some description from developers or pervious reseachers

> This PR fix a bug of wait.poller(). wait.poller() returns a function with type WaitFunc. 
> the function creates a goroutine and the goroutine only quits when after or done closed.
  
> In cache.WaitForCacheSync, after is nil and done is never closed. Then the goroutine 
> never stops.

See the [bug kernel](../../../../goker/blocking/kubernetes/70277/README.md)

## Backtrace

```
panic: expected an ack of the done signal [recovered]
	panic: expected an ack of the done signal

goroutine 7 [running]:
testing.tRunner.func1(0xc0000c8100)
	/usr/local/go/src/testing/testing.go:830 +0x392
panic(0x51d720, 0x578620)
	/usr/local/go/src/runtime/panic.go:522 +0x1b5
k8s.io/apimachinery/pkg/util/wait.TestWaitForClosesStopCh(0xc0000c8100)
	/go/src/k8s.io/apimachinery/pkg/util/wait/wait_test.go:500 +0x197
testing.tRunner(0xc0000c8100, 0x55cd10)
	/usr/local/go/src/testing/testing.go:865 +0xc0
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:916 +0x35a

goroutine 1 [chan receive]:
testing.(*T).Run(0xc0000c8100, 0x556b7d, 0x17, 0x55cd10, 0x46d901)
	/usr/local/go/src/testing/testing.go:917 +0x381
testing.runTests.func1(0xc0000c8000)
	/usr/local/go/src/testing/testing.go:1157 +0x78
testing.tRunner(0xc0000c8000, 0xc000095e30)
	/usr/local/go/src/testing/testing.go:865 +0xc0
testing.runTests(0xc00000e0a0, 0x65d0c0, 0x13, 0x13, 0x0)
	/usr/local/go/src/testing/testing.go:1155 +0x2a9
testing.(*M).Run(0xc0000ae000, 0x0)
	/usr/local/go/src/testing/testing.go:1072 +0x162
main.main()
	_testmain.go:78 +0x13e

goroutine 5 [chan receive]:
k8s.io/klog.(*loggingT).flushDaemon(0x6603a0)
	/go/src/k8s.io/klog/klog.go:941 +0x8b
created by k8s.io/klog.init.0
	/go/src/k8s.io/klog/klog.go:403 +0x6c
```

