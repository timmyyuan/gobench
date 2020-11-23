
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#35931]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[cockroach#35931]:(cockroach35931_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/35931/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/35931
 
## Description

Some description from developers or pervious reseachers

> Previously, if a processor that reads from multiple inputs was waiting
  on one input to provide more data, and the other input was full, and
  both inputs were connected to inbound streams, it was possible to
  deadlock the system during flow cancellation when trying to propagate
  the cancellation metadata messages into the flow. The problem was that
  the cancellation method wrote metadata messages to each inbound stream
  one at a time, so if the first one was full, the canceller would block
  and never send a cancellation message to the second stream, which was
  the one actually being read from.

See its [bug kernel](../../../../goker/blocking/cockroach/35931/README.md)

## Backtrace

```
goroutine 10 [chan send, 10 minutes]:
github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.(*RowChannel).Push(0xc000507100, 0x0, 0x0, 0x0, 0xc00040af60, 0x2)
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/base.go:431 +0xd4
github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.(*Flow).cancel(0xc000196b40)
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/flow.go:707 +0x13c
github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.TestFlowCancelPartiallyBlocked(0xc000608700)
	/go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/flow_registry_test.go:713 +0x471
testing.tRunner(0xc000608700, 0x2ae3990)
	/usr/local/go/src/testing/testing.go:827 +0xbf
created by testing.(*T).Run
	/usr/local/go/src/testing/testing.go:878 +0x35c
```

