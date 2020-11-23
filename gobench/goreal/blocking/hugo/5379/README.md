
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[hugo#5379]|[pull request]|[patch]| Blocking | Resource Deadlock | Double Locking |

[hugo#5379]:(hugo5379_test.go)
[patch]:https://github.com/gohugoio/hugo/pull/5379/files
[pull request]:https://github.com/gohugoio/hugo/pull/5379
 
## Description

See the [bug kernel](../../../../goker/blocking/hugo/5379/README.md)

## Backtrace

Too many goroutines, please see the source code or log files. Here are some of them

```
goroutine 35 [chan send, 9 minutes]:
github.com/gohugoio/hugo/hugolib.(*Site).renderPages(0xc00019c000, 0xc00082bd98, 0x18, 0x0)
	/go/src/github.com/gohugoio/hugo/hugolib/site_render.go:53 +0x217
github.com/gohugoio/hugo/hugolib.(*Site).render(0xc00019c000, 0xc000289d98, 0x0, 0x0, 0x1)
	/go/src/github.com/gohugoio/hugo/hugolib/site.go:1054 +0x57
github.com/gohugoio/hugo/hugolib.(*HugoSites).render(0xc000067580, 0xc00082bd98, 0xc000067580, 0xc000782900)
	/go/src/github.com/gohugoio/hugo/hugolib/hugo_sites_build.go:302 +0x336
github.com/gohugoio/hugo/hugolib.(*HugoSites).Build(0xc000067580, 0x0, 0xc000771560, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2000, 0xc000277c40)
	/go/src/github.com/gohugoio/hugo/hugolib/hugo_sites_build.go:97 +0x44f
github.com/gohugoio/hugo/hugolib.(*sitesBuilder).build(0xc0000a0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2)
	/go/src/github.com/gohugoio/hugo/hugolib/testhelpers_test.go:376 +0x6c
github.com/gohugoio/hugo/hugolib.(*sitesBuilder).Build(...)
	/go/src/github.com/gohugoio/hugo/hugolib/testhelpers_test.go:364
github.com/gohugoio/hugo/hugolib.TestSiteBuildTimeout(0xc0000ca200)
	/go/src/github.com/gohugoio/hugo/hugolib/hugo_sites_build_errors_test.go:345 +0x547
testing.tRunner(0xc0000ca200, 0x1097f58)
	/usr/local/go/src/testing/testing.go:909 +0xc9
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:960 +0x350

goroutine 113 [semacquire, 9 minutes]:
sync.runtime_SemacquireMutex(0xc000158db4, 0xc000783600, 0x1)
	/usr/local/go/src/runtime/sema.go:71 +0x47
sync.(*Mutex).lockSlow(0xc000158db0)
	/usr/local/go/src/sync/mutex.go:138 +0xfc
sync.(*Mutex).Lock(...)
	/usr/local/go/src/sync/mutex.go:81
github.com/gohugoio/hugo/hugolib.(*Page).initPlain.func1()
	/go/src/github.com/gohugoio/hugo/hugolib/page.go:571 +0xfe
sync.(*Once).doSlow(0xc000158dc4, 0xc0008109b8)
	/usr/local/go/src/sync/once.go:66 +0xe3
sync.(*Once).Do(...)
	/usr/local/go/src/sync/once.go:57
github.com/gohugoio/hugo/hugolib.(*Page).initPlain(0xc0007f8500, 0x1234501)
	/go/src/github.com/gohugoio/hugo/hugolib/page.go:569 +0x83
github.com/gohugoio/hugo/hugolib.(*Page).initContentPlainAndMeta(0xc0007f8500)
	/go/src/github.com/gohugoio/hugo/hugolib/page.go:958 +0x3e
github.com/gohugoio/hugo/hugolib.(*Page).WordCount(0xc0007f8500, 0x0)
	/go/src/github.com/gohugoio/hugo/hugolib/page.go:942 +0x2b
reflect.Value.call(0xfc5ba0, 0xc0002e4f00, 0x16213, 0xfc95f2, 0x4, 0x195cb50, 0x0, 0x0, 0x1, 0x11, ...)
	/usr/local/go/src/reflect/value.go:460 +0x5f6
reflect.Value.Call(0xfc5ba0, 0xc0002e4f00, 0x16213, 0x195cb50, 0x0, 0x0, 0xc000810d40, 0x441303, 0xfc5ba0)
	/usr/local/go/src/reflect/value.go:321 +0xb4
text/template.safeCall(0xfc5ba0, 0xc0002e4f00, 0x16213, 0x195cb50, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
	/usr/local/go/src/text/template/funcs.go:352 +0xda
text/template.(*state).evalCall(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0xfc5ba0, 0xc0002e4f00, 0x16213, 0x12034a0, 0xc0004ef830, 0xc00032bc85, ...)
	/usr/local/go/src/text/template/exec.go:713 +0x686
text/template.(*state).evalField(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0xc00032bc85, 0x9, 0x12034a0, 0xc0004ef830, 0xc0005645b0, 0x1, ...)
	/usr/local/go/src/text/template/exec.go:597 +0xd2f
text/template.(*state).evalFieldChain(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0xfc5ba0, 0xc0002e4f00, 0x16, 0x12034a0, 0xc0004ef830, 0xc0005645a0, ...)
	/usr/local/go/src/text/template/exec.go:558 +0x220
text/template.(*state).evalFieldNode(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0xc0004ef830, 0xc0005645b0, 0x1, 0x1, 0xed7600, 0x195cb50, ...)
	/usr/local/go/src/text/template/exec.go:522 +0x113
text/template.(*state).evalCommand(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0xc0004ef800, 0xed7600, 0x195cb50, 0x99, 0xe820a0, 0x6c00000001, ...)
	/usr/local/go/src/text/template/exec.go:460 +0x79a
text/template.(*state).evalPipeline(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0xc0005022a0, 0x0, 0x0, 0x1)
	/usr/local/go/src/text/template/exec.go:434 +0x11a
text/template.(*state).walk(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0x1203320, 0xc0004ef860)
	/usr/local/go/src/text/template/exec.go:258 +0x49b
text/template.(*state).walk(0xc0008115a8, 0xfc5ba0, 0xc0002e4f00, 0x16, 0x1203560, 0xc0004ef7a0)
	/usr/local/go/src/text/template/exec.go:266 +0x142
text/template.(*Template).execute(0xc00053cf80, 0x11e9080, 0xc0007aa7b0, 0xfc5ba0, 0xc0002e4f00, 0x0, 0x0)
	/usr/local/go/src/text/template/exec.go:221 +0x20a
text/template.(*Template).Execute(...)
	/usr/local/go/src/text/template/exec.go:204
html/template.(*Template).Execute(0xc0004ef740, 0x11e9080, 0xc0007aa7b0, 0xfc5ba0, 0xc0002e4f00, 0xc87596, 0xf4ea60)
	/usr/local/go/src/html/template/template.go:122 +0x8c
github.com/gohugoio/hugo/tpl.(*TemplateAdapter).Execute(0xc0006b6140, 0x11e9080, 0xc0007aa7b0, 0xfc5ba0, 0xc0002e4f00, 0x0, 0x0)
	/go/src/github.com/gohugoio/hugo/tpl/template.go:128 +0xd6
github.com/gohugoio/hugo/hugolib.(*Site).renderForLayouts(0xc00019c000, 0xfca776, 0x4, 0xfc5ba0, 0xc0002e4f00, 0x11e9080, 0xc0007aa7b0, 0xc000203b00, 0x8, 0x8, ...)
	/go/src/github.com/gohugoio/hugo/hugolib/site.go:1749 +0xb8
github.com/gohugoio/hugo/hugolib.(*Site).renderAndWritePage(0xc00019c000, 0xc0000b2c40, 0xc000811c30, 0xd, 0xc0006f53e0, 0x11, 0xc0002e4f00, 0xc000203b00, 0x8, 0x8, ...)
	/go/src/github.com/gohugoio/hugo/hugolib/site.go:1691 +0x12c
github.com/gohugoio/hugo/hugolib.pageRenderer(0xc00019c000, 0xc000351200, 0xc0003511a0, 0xc0003188e0)
	/go/src/github.com/gohugoio/hugo/hugolib/site_render.go:169 +0x705
created by github.com/gohugoio/hugo/hugolib.(*Site).renderPages
	/go/src/github.com/gohugoio/hugo/hugolib/site_render.go:43 +0x160

...
```

