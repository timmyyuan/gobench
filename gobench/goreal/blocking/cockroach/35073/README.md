
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#35073]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[cockroach#35073]:(cockroach35073_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/35073/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/35073
 
## Description

Some description from developers or pervious reseachers

> Previously, the outbox could fail during startup without closing its
  RowChannel. This could lead to deadlocked flows in rare cases.

See its [bug kernel](../../../../goker/blocking/cockroach/35073/README.md)

## Backtrace

```
goroutine 30 [chan send, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.(*RowChannel).Push(...)
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/base.go:432
github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.TestOutboxUnblocksProducers(0xc00019e700)
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/outbox_test.go:497 +0x661
testing.tRunner(0xc00019e700, 0x2a7c850)
	/usr/local/go/src/testing/testing.go:827 +0xbf
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:878 +0x35c

goroutine 31 [chan send, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.(*RowChannel).Push(...)
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/base.go:432
github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.TestOutboxUnblocksProducers.func1(0xc0005ca700, 0xc000214c50)
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/outbox_test.go:486 +0xcc
created by github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.TestOutboxUnblocksProducers
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/outbox_test.go:483 +0x494
```

