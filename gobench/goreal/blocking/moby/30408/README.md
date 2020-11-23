
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[moby#30408]|[pull request]|[patch]| Blocking | Communication Deadlock | Condition Variable |

[moby#30408]:(moby30408_test.go)
[patch]:https://github.com/moby/moby/pull/30408/files
[pull request]:https://github.com/moby/moby/pull/30408
 
## Description

Some description from developers or pervious reseachers

> When a plugin has an activation error, it was not being checked in the
  waitActive loop. This means it will just wait forever for a manifest
  to be populated even though it may never come.

See the [bug kernel](../../../../goker/blocking/moby/30408/README.md)

## Backtrace

```
goroutine 18 [running]:
panic(0x68bec0, 0xc4200128e0)
	/usr/local/go/src/runtime/panic.go:500 +0x1a1
testing.tRunner.func1(0xc4200f6180)
	/usr/local/go/src/testing/testing.go:579 +0x25d
panic(0x68bec0, 0xc4200128e0)
	/usr/local/go/src/runtime/panic.go:458 +0x243
github.com/docker/docker/pkg/plugins.testActive(0xc4200f6180, 0xc42009c3c0)
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:43 +0x301
github.com/docker/docker/pkg/plugins.TestPluginWaitBadPlugin(0xc4200f6180)
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:29 +0x163
testing.tRunner(0xc4200f6180, 0x71b6b8)
	/usr/local/go/src/testing/testing.go:610 +0x81
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:646 +0x2ec

goroutine 1 [chan receive]:
testing.(*T).Run(0xc4200f60c0, 0x6f94a4, 0x17, 0x71b6b8, 0xc42003dd01)
	/usr/local/go/src/testing/testing.go:647 +0x316
testing.RunTests.func1(0xc4200f60c0)
	/usr/local/go/src/testing/testing.go:793 +0x6d
testing.tRunner(0xc4200f60c0, 0xc42003de20)
	/usr/local/go/src/testing/testing.go:610 +0x81
testing.RunTests(0x71b700, 0x83df60, 0xb, 0xb, 0x40f898)
	/usr/local/go/src/testing/testing.go:799 +0x2f5
testing.(*M).Run(0xc42003dee8, 0x0)
	/usr/local/go/src/testing/testing.go:743 +0x85
main.main()
	github.com/docker/docker/pkg/plugins/_test/_testmain.go:74 +0xc6

goroutine 19 [semacquire]:
sync.runtime_notifyListWait(0xc420098390, 0x0)
	/usr/local/go/src/runtime/sema.go:267 +0x122
sync.(*Cond).Wait(0xc420098380)
	/usr/local/go/src/sync/cond.go:57 +0x80
github.com/docker/docker/pkg/plugins.(*Plugin).waitActive(0xc42009c3c0, 0x0, 0x0)
	/go/src/github.com/docker/docker/pkg/plugins/plugins.go:173 +0x56
github.com/docker/docker/pkg/plugins.testActive.func1(0xc42009c3c0, 0xc42009c420)
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:35 +0x2b
created by github.com/docker/docker/pkg/plugins.testActive
	/go/src/github.com/docker/docker/pkg/plugins/plugin_test.go:37 +0x7f
```

