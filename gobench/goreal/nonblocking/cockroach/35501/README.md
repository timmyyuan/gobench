
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#35501]|[pull request]|[patch]| NonBlocking | Go-Specific | Anonymous Function |

[cockroach#35501]:(cockroach35501_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/35501/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/35501
 

## Backtrace

```
Read at 0x00c001986368 by goroutine 242:
  github.com/cockroachdb/cockroach/pkg/sql.validateCheckInTxn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:1015 +0x21c
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).validateChecks.func1.1()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:266 +0x329
  github.com/cockroachdb/cockroach/pkg/util/ctxgroup.Group.GoCtx.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/util/ctxgroup/ctxgroup.go:170 +0x4e
  github.com/cockroachdb/cockroach/vendor/golang.org/x/sync/errgroup.(*Group).Go.func1()
      /go/src/github.com/cockroachdb/cockroach/vendor/golang.org/x/sync/errgroup/errgroup.go:57 +0x71

Previous write at 0x00c001986368 by goroutine 126:
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).validateChecks.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:247 +0x303
  github.com/cockroachdb/cockroach/pkg/internal/client.(*DB).Txn.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/db.go:585 +0x5e
  github.com/cockroachdb/cockroach/pkg/internal/client.(*Txn).exec()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/txn.go:688 +0xe9
  github.com/cockroachdb/cockroach/pkg/internal/client.(*DB).Txn()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/db.go:584 +0x124
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).validateChecks()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:231 +0x187
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).runBackfill()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:214 +0x67a
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).runStateMachineAndBackfill()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/schema_changer.go:1098 +0xfa
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).exec()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/schema_changer.go:851 +0x53c
  github.com/cockroachdb/cockroach/pkg/sql.(*schemaChangerCollection).execSchemaChanges()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/exec_util.go:955 +0x28f
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).txnStateTransitionsApplyWrapper()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1982 +0x144c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1306 +0x1344
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1306 +0x1344
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*Server).ServeConn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:429 +0x12b
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.(*conn).serveImpl.func4()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/conn.go:331 +0x115

Goroutine 242 (running) created at:
  github.com/cockroachdb/cockroach/vendor/golang.org/x/sync/errgroup.(*Group).Go()
      /go/src/github.com/cockroachdb/cockroach/vendor/golang.org/x/sync/errgroup/errgroup.go:54 +0x73
  github.com/cockroachdb/cockroach/pkg/util/ctxgroup.Group.GoCtx()
      /go/src/github.com/cockroachdb/cockroach/pkg/util/ctxgroup/ctxgroup.go:169 +0xda
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).validateChecks.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:248 +0x518
  github.com/cockroachdb/cockroach/pkg/internal/client.(*DB).Txn.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/db.go:585 +0x5e
  github.com/cockroachdb/cockroach/pkg/internal/client.(*Txn).exec()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/txn.go:688 +0xe9
  github.com/cockroachdb/cockroach/pkg/internal/client.(*DB).Txn()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/db.go:584 +0x124
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).validateChecks()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:231 +0x187
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).runBackfill()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/backfill.go:214 +0x67a
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).runStateMachineAndBackfill()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/schema_changer.go:1098 +0xfa
  github.com/cockroachdb/cockroach/pkg/sql.(*SchemaChanger).exec()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/schema_changer.go:851 +0x53c
  github.com/cockroachdb/cockroach/pkg/sql.(*schemaChangerCollection).execSchemaChanges()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/exec_util.go:955 +0x28f
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).txnStateTransitionsApplyWrapper()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1982 +0x144c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1306 +0x1344
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1306 +0x1344
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1178 +0x355c
  github.com/cockroachdb/cockroach/pkg/sql.(*Server).ServeConn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:429 +0x12b
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.(*conn).serveImpl.func4()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/conn.go:331 +0x115

Goroutine 126 (running) created at:
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.(*conn).serveImpl()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/conn.go:314 +0x14c4
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.serveConn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/conn.go:167 +0x2a4
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.(*Server).ServeConn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/server.go:517 +0xc71
  github.com/cockroachdb/cockroach/pkg/server.(*Server).Start.func20.1()
      /go/src/github.com/cockroachdb/cockroach/pkg/server/server.go:1712 +0x1a0
  github.com/cockroachdb/cockroach/pkg/util/netutil.(*Server).ServeWith.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/util/netutil/net.go:139 +0x104
```

