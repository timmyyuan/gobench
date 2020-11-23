
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[hugo#3251]|[pull request]|[patch]| Blocking | Resource Deadlock | AB-BA Deadlock |

[hugo#3251]:(hugo3251_test.go)
[patch]:https://github.com/gohugoio/hugo/pull/3251/files
[pull request]:https://github.com/gohugoio/hugo/pull/3251
 
## Description

See the [bug kernel](../../../../goker/blocking/hugo/3251)

## Backtrace

Too many goroutines, please see the source code or the log file. Here is some of them:

```
goroutine 27 [semacquire]:
sync.runtime_SemacquireMutex(0x10fba04, 0xc72500, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0x10fba00)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
	/usr/local/go/src/sync/mutex.go:81
sync.(*RWMutex).Lock(0x10fba00)
	/usr/local/go/src/sync/rwmutex.go:98 +0x97
github.com/spf13/hugo/tpl/tplimpl.(*remoteLock).URLLock(0x10fba00, 0xb72d04, 0x1a)
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources.go:48 +0x31
github.com/spf13/hugo/tpl/tplimpl.resGetRemote(0xb72d04, 0x1a, 0xc8ac20, 0xc00019eb10, 0xc87ca0, 0xc0001804b0, 0xc00019ec30, 0x0, 0x0, 0x0, ...)
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources.go:125 +0x132
github.com/spf13/hugo/tpl/tplimpl.TestScpGetRemoteParallel.func3(0xc0001a0400, 0xb72d04, 0x1a, 0xc00019eb10, 0xc0001804b0, 0xc00019ec30, 0xc00013a800, 0xc0000d9960, 0x12, 0x12, ...)
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources_test.go:202 +0xf1
created by github.com/spf13/hugo/tpl/tplimpl.TestScpGetRemoteParallel
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources_test.go:199 +0x25d

goroutine 72 [semacquire]:
sync.runtime_SemacquireMutex(0x10fba0c, 0x0, 0x0)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*RWMutex).RLock(...)
	/usr/local/go/src/sync/rwmutex.go:50
github.com/spf13/hugo/tpl/tplimpl.(*remoteLock).URLUnlock(0x10fba00, 0xb72d04, 0x1a)
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources.go:58 +0x106
github.com/spf13/hugo/tpl/tplimpl.resGetRemote.func1(0xb72d04, 0x1a)
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources.go:126 +0x41
github.com/spf13/hugo/tpl/tplimpl.resGetRemote(0xb72d04, 0x1a, 0xc8ac20, 0xc000196b10, 0xc87ca0, 0xc0001784b0, 0xc000196c30, 0xc00027a000, 0x12, 0x200, ...)
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources.go:152 +0x598
github.com/spf13/hugo/tpl/tplimpl.TestScpGetRemoteParallel.func3(0xc000198400, 0xb72d04, 0x1a, 0xc000196b10, 0xc0001784b0, 0xc000196c30, 0xc000132800, 0xc0000d1960, 0x12, 0x12, ...)
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources_test.go:202 +0xf1
created by github.com/spf13/hugo/tpl/tplimpl.TestScpGetRemoteParallel
	/go/src/github.com/spf13/hugo/tpl/tplimpl/template_resources_test.go:199 +0x25d

goroutine 74 [IO wait]:
internal/poll.runtime_pollWait(0x7f1ff667ee28, 0x72, 0xffffffffffffffff)
	/usr/local/go/src/runtime/netpoll.go:184 +0x55
internal/poll.(*pollDesc).wait(0xc0000e7218, 0x72, 0x1000, 0x1000, 0xffffffffffffffff)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:87 +0x45
internal/poll.(*pollDesc).waitRead(...)
	/usr/local/go/src/internal/poll/fd_poll_runtime.go:92
internal/poll.(*FD).Read(0xc0000e7200, 0xc0001ab000, 0x1000, 0x1000, 0x0, 0x0, 0x0)
	/usr/local/go/src/internal/poll/fd_unix.go:169 +0x1cf
net.(*netFD).Read(0xc0000e7200, 0xc0001ab000, 0x1000, 0x1000, 0x400, 0x7f1ff86edc00, 0x20300000000000)
	/usr/local/go/src/net/fd_unix.go:202 +0x4f
net.(*conn).Read(0xc0000968f0, 0xc0001ab000, 0x1000, 0x1000, 0x0, 0x0, 0x0)
	/usr/local/go/src/net/net.go:184 +0x68
net/http.(*connReader).Read(0xc0001972f0, 0xc0001ab000, 0x1000, 0x1000, 0xc0000b7cc0, 0x109e2c4, 0x2)
	/usr/local/go/src/net/http/server.go:796 +0xf4
bufio.(*Reader).fill(0xc00019e8a0)
	/usr/local/go/src/bufio/bufio.go:100 +0x103
bufio.(*Reader).ReadSlice(0xc00019e8a0, 0xa, 0x7f1ff667c730, 0xc0002399a8, 0x40dbc6, 0xc000276000, 0x100)
	/usr/local/go/src/bufio/bufio.go:359 +0x3d
bufio.(*Reader).ReadLine(0xc00019e8a0, 0xc0002399b0, 0xc000040700, 0x7f1ffa8eb008, 0x0, 0x0, 0xc0002399f0)
	/usr/local/go/src/bufio/bufio.go:388 +0x34
net/textproto.(*Reader).readLineSlice(0xc000197320, 0xc000276000, 0xc0000e7200, 0x0, 0x0, 0x48950d)
	/usr/local/go/src/net/textproto/reader.go:57 +0x6c
net/textproto.(*Reader).ReadLine(...)
	/usr/local/go/src/net/textproto/reader.go:38
net/http.readRequest(0xc00019e8a0, 0x0, 0xc000276000, 0x0, 0x0)
	/usr/local/go/src/net/http/request.go:1012 +0x92
net/http.(*conn).readRequest(0xc000175540, 0xc81820, 0xc0000b7c80, 0x0, 0x0, 0x0)
	/usr/local/go/src/net/http/server.go:982 +0x15f
net/http.(*conn).serve(0xc000175540, 0xc81820, 0xc0000b7c80)
	/usr/local/go/src/net/http/server.go:1845 +0x6d4
created by net/http.(*Server).Serve
	/usr/local/go/src/net/http/server.go:2957 +0x384

...
```

