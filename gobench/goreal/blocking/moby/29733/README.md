
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[moby#29733]|[pull request]|[patch]| Blocking | Communication Deadlock | Condition Variable |

[moby#29733]:(moby29733_test.go)
[patch]:https://github.com/moby/moby/pull/29733/files
[pull request]:https://github.com/moby/moby/pull/29733
 
## Description

Some description from developers or pervious reseachers

> When a plugin is activated, and then plugins.Handle is called to
  register a new handler for a given plugin type, a deadlock occurs for anything which calls waitActive, including Get, and GetAll.
  
> This happens because Handle() is setting activated to false to
  ensure that plugin handlers are run on next activation.

See the [bug kernel](../../../../goker/blocking/moby/29733/README.md)

## Backtrace

```
goroutine 6 [running]:
panic(0x68aea0, 0xc4200dc030)
	/usr/local/go/src/runtime/panic.go:500 +0x1a1
testing.tRunner.func1(0xc420088180)
	/usr/local/go/src/testing/testing.go:579 +0x25d
panic(0x68aea0, 0xc4200dc030)
	/usr/local/go/src/runtime/panic.go:458 +0x243
github.com/docker/docker/pkg/plugins.testActive(0xc420088180, 0xc42006c540)
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:36 +0x301
github.com/docker/docker/pkg/plugins.TestPluginAddHandler(0xc420088180)
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:20 +0x1d8
testing.tRunner(0xc420088180, 0x71a608)
	/usr/local/go/src/testing/testing.go:610 +0x81
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:646 +0x2ec

goroutine 1 [chan receive]:
testing.(*T).Run(0xc4200880c0, 0x6f721d, 0x14, 0x71a608, 0xc42003dd01)
	/usr/local/go/src/testing/testing.go:647 +0x316
testing.RunTests.func1(0xc4200880c0)
	/usr/local/go/src/testing/testing.go:793 +0x6d
testing.tRunner(0xc4200880c0, 0xc42003de20)
	/usr/local/go/src/testing/testing.go:610 +0x81
testing.RunTests(0x71a650, 0x83bf60, 0xa, 0xa, 0x40f898)
	/usr/local/go/src/testing/testing.go:799 +0x2f5
testing.(*M).Run(0xc42003dee8, 0x0)
	/usr/local/go/src/testing/testing.go:743 +0x85
main.main()
	github.com/docker/docker/pkg/plugins/_test/_testmain.go:72 +0xc6

goroutine 7 [semacquire]:
sync.runtime_notifyListWait(0xc420010a10, 0x0)
	/usr/local/go/src/runtime/sema.go:267 +0x122
sync.(*Cond).Wait(0xc420010a00)
	/usr/local/go/src/sync/cond.go:57 +0x80
github.com/docker/docker/pkg/plugins.(*Plugin).waitActive(0xc42006c540, 0x0, 0x0)
	/go/src/github.com/docker/docker/pkg/plugins/plugins.go:159 +0x55
github.com/docker/docker/pkg/plugins.testActive.func1(0xc42006c540, 0xc42006c5a0)
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:28 +0x2b
created by github.com/docker/docker/pkg/plugins.testActive
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:30 +0x7f
```

