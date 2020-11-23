
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[istio#18454]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel & Context |

[istio#18454]:(istio18454_test.go)
[patch]:https://github.com/istio/istio/pull/18454/files
[pull request]:https://github.com/istio/istio/pull/18454
 
## Description

Some description from developers or pervious reseachers

> fixed a bug in the publish strateg's time reset code which could
  lead to deadlock.

See the [bug kernel](../../../../goker/blocking/istio/18454/README.md)

## Backtrace

```
goroutine 22 [select]:
go.opencensus.io/stats/view.(*worker).start(0xc0000d1310)
    /go/pkg/mod/go.opencensus.io@v0.21.0/stats/view/worker.go:154 +0x100
created by go.opencensus.io/stats/view.init.0
    /go/pkg/mod/go.opencensus.io@v0.21.0/stats/view/worker.go:32 +0x57
```

