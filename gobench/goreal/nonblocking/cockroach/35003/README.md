
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#35003]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[cockroach#35003]:(cockroach35003_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/35003/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/35003
 

## Backtrace

```
Read at 0x00c0030aabd0 by goroutine 1090:
  encoding/json.encodeByteSlice()
      /usr/local/go/src/reflect/value.go:1078 +0x528
  encoding/json.structEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:664 +0x40d
  encoding/json.structEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:635 +0xa0
  encoding/json.structEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:664 +0x40d
  encoding/json.structEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:635 +0xa0
  encoding/json.ptrEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:810 +0xfc
  encoding/json.ptrEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:805 +0x7b
  encoding/json.structEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:664 +0x40d
  encoding/json.structEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:635 +0xa0
  encoding/json.ptrEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:810 +0xfc
  encoding/json.ptrEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:805 +0x7b
  encoding/json.(*encodeState).reflectValue()
      /usr/local/go/src/encoding/json/encode.go:337 +0x93
  encoding/json.interfaceEncoder()
      /usr/local/go/src/encoding/json/encode.go:619 +0xf7
  encoding/json.structEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:664 +0x40d
  encoding/json.structEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:635 +0xa0
  encoding/json.arrayEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:791 +0xe3
  encoding/json.arrayEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:784 +0x7b
  encoding/json.sliceEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:765 +0xda
  encoding/json.sliceEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:760 +0x7b
  encoding/json.structEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:664 +0x40d
  encoding/json.structEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:635 +0xa0
  encoding/json.ptrEncoder.encode()
      /usr/local/go/src/encoding/json/encode.go:810 +0xfc
  encoding/json.ptrEncoder.encode-fm()
      /usr/local/go/src/encoding/json/encode.go:805 +0x7b
  encoding/json.(*encodeState).reflectValue()
      /usr/local/go/src/encoding/json/encode.go:337 +0x93
  encoding/json.(*encodeState).marshal()
      /usr/local/go/src/encoding/json/encode.go:309 +0xcc
  encoding/json.(*Encoder).Encode()
      /usr/local/go/src/encoding/json/stream.go:202 +0xd7
  github.com/cockroachdb/cockroach/pkg/kv.GRPCTransportFactory.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/transport_race.go:129 +0x1f0
  github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunAsyncTask.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:325 +0x162

Previous write at 0x00c0030aabd0 by goroutine 1191:
  github.com/cockroachdb/cockroach/pkg/kv.(*txnCommitter).SendLocked()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_committer.go:56 +0x107
  github.com/cockroachdb/cockroach/pkg/kv.(*txnSpanRefresher).sendLockedWithRefreshAttempts()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_span_refresher.go:160 +0xd0
  github.com/cockroachdb/cockroach/pkg/kv.(*txnSpanRefresher).maybeRetrySend()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_span_refresher.go:224 +0x335
  github.com/cockroachdb/cockroach/pkg/kv.(*txnSpanRefresher).sendLockedWithRefreshAttempts()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_span_refresher.go:162 +0x209
  github.com/cockroachdb/cockroach/pkg/kv.(*txnSpanRefresher).sendLockedWithRefreshAttempts()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_span_refresher.go:160 +0xd0
  github.com/cockroachdb/cockroach/pkg/kv.(*txnSpanRefresher).SendLocked()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_span_refresher.go:101 +0x196
  github.com/cockroachdb/cockroach/pkg/kv.(*txnPipeliner).SendLocked()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_pipeliner.go:164 +0x378
  github.com/cockroachdb/cockroach/pkg/kv.(*txnIntentCollector).SendLocked()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_intent_collector.go:101 +0x5ab
  github.com/cockroachdb/cockroach/pkg/kv.(*txnSeqNumAllocator).SendLocked()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_seq_num_allocator.go:92 +0x345
  github.com/cockroachdb/cockroach/pkg/kv.(*txnHeartbeater).SendLocked()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_interceptor_heartbeater.go:225 +0x17f
  github.com/cockroachdb/cockroach/pkg/kv.(*TxnCoordSender).Send()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/txn_coord_sender.go:708 +0xa4a
  github.com/cockroachdb/cockroach/pkg/internal/client.(*DB).sendUsingSender()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/db.go:622 +0x173
  github.com/cockroachdb/cockroach/pkg/internal/client.(*Txn).Send()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/txn.go:802 +0x1d1
  github.com/cockroachdb/cockroach/pkg/internal/client.(*Txn).Send-fm()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/txn.go:786 +0xbc
  github.com/cockroachdb/cockroach/pkg/internal/client.sendAndFill()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/db.go:547 +0x159
  github.com/cockroachdb/cockroach/pkg/internal/client.(*Txn).Run()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/txn.go:497 +0x11f
  github.com/cockroachdb/cockroach/pkg/internal/client.(*Txn).CommitInBatch()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/txn.go:547 +0x230
  github.com/cockroachdb/cockroach/pkg/sql.(*tableWriterBase).finalize()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/tablewriter.go:162 +0xa5
  github.com/cockroachdb/cockroach/pkg/sql.(*insertNode).BatchedNext()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/tablewriter_insert.go:58 +0x526
  github.com/cockroachdb/cockroach/pkg/sql.(*rowCountNode).startExec()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/plan_batch.go:173 +0x150
  github.com/cockroachdb/cockroach/pkg/sql.startExec.func2()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/plan.go:514 +0x70
  github.com/cockroachdb/cockroach/pkg/sql.(*planVisitor).visitInternal.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/walk.go:141 +0x99
  github.com/cockroachdb/cockroach/pkg/sql.(*planVisitor).visitInternal()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/walk.go:609 +0x57a
  github.com/cockroachdb/cockroach/pkg/sql.(*planVisitor).visit()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/walk.go:108 +0xf9
  github.com/cockroachdb/cockroach/pkg/sql.startExec()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/walk.go:72 +0x27b
  github.com/cockroachdb/cockroach/pkg/sql.(*planNodeToRowSource).Start()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/plan_node_to_row_source.go:124 +0x1c8
  github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.(*ProcessorBase).Run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/processors.go:800 +0x8a
  github.com/cockroachdb/cockroach/pkg/sql.(*planNodeToRowSource).Run()
      <autogenerated>:1 +0x57
  github.com/cockroachdb/cockroach/pkg/sql/distsqlrun.(*Flow).Run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/distsqlrun/flow.go:649 +0x165
  github.com/cockroachdb/cockroach/pkg/sql.(*DistSQLPlanner).Run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/distsql_running.go:252 +0xcc3
  github.com/cockroachdb/cockroach/pkg/sql.(*DistSQLPlanner).PlanAndRun()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/distsql_running.go:795 +0x25d
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execWithDistSQLEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:1046 +0x5ac
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).dispatchToExecutionEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:900 +0xaa4
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmtInOpenState()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:438 +0x1207
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmt()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:93 +0x390
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*DistSQLPlanner).PlanAndRun()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/distsql_running.go:795 +0x25d
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execWithDistSQLEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:1046 +0x5ac
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).dispatchToExecutionEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:900 +0xaa4
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmtInOpenState()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:438 +0x1207
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmt()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:93 +0x390
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*DistSQLPlanner).PlanAndRun()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/distsql_running.go:795 +0x25d
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execWithDistSQLEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:1046 +0x5ac
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).dispatchToExecutionEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:900 +0xaa4
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmtInOpenState()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:438 +0x1207
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmt()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:93 +0x390
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*DistSQLPlanner).PlanAndRun()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/distsql_running.go:795 +0x25d
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execWithDistSQLEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:1046 +0x5ac
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).dispatchToExecutionEngine()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:900 +0xaa4
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmtInOpenState()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:438 +0x1207
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).execStmt()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor_exec.go:93 +0x390
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*connExecutor).run()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:1182 +0x34fe
  github.com/cockroachdb/cockroach/pkg/sql.(*Server).ServeConn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/conn_executor.go:429 +0x12b
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.(*conn).serveImpl.func4()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/conn.go:331 +0x115

Goroutine 1090 (running) created at:
  github.com/cockroachdb/cockroach/pkg/util/stop.(*Stopper).RunAsyncTask()
      /go/src/github.com/cockroachdb/cockroach/pkg/util/stop/stopper.go:320 +0x14a
  github.com/cockroachdb/cockroach/pkg/kv.GRPCTransportFactory()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/transport_race.go:107 +0x2ad
  github.com/cockroachdb/cockroach/pkg/kv.(*DistSender).sendToReplicas()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/dist_sender.go:1350 +0x119
  github.com/cockroachdb/cockroach/pkg/kv.(*DistSender).sendRPC()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/dist_sender.go:416 +0x32d
  github.com/cockroachdb/cockroach/pkg/kv.(*DistSender).sendSingleRange()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/dist_sender.go:496 +0x20b
  github.com/cockroachdb/cockroach/pkg/kv.(*DistSender).sendPartialBatch()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/dist_sender.go:1139 +0x3e7
  github.com/cockroachdb/cockroach/pkg/kv.(*DistSender).divideAndSendBatchToRanges()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/dist_sender.go:798 +0x1b6f
  github.com/cockroachdb/cockroach/pkg/kv.(*DistSender).Send()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/dist_sender.go:710 +0x6ca
  github.com/cockroachdb/cockroach/pkg/internal/client.lookupRangeFwdScan()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/range_lookup.go:318 +0x4a9
  github.com/cockroachdb/cockroach/pkg/internal/client.RangeLookup()
      /go/src/github.com/cockroachdb/cockroach/pkg/internal/client/range_lookup.go:201 +0x6b9
  github.com/cockroachdb/cockroach/pkg/kv.(*DistSender).RangeLookup()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/dist_sender.go:343 +0xba
  github.com/cockroachdb/cockroach/pkg/kv.(*RangeDescriptorCache).performRangeLookup()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/range_cache.go:412 +0x449
  github.com/cockroachdb/cockroach/pkg/kv.(*RangeDescriptorCache).lookupRangeDescriptorInternal.func3()
      /go/src/github.com/cockroachdb/cockroach/pkg/kv/range_cache.go:285 +0x17f
  github.com/cockroachdb/cockroach/pkg/util/syncutil/singleflight.(*Group).doCall()
      /go/src/github.com/cockroachdb/cockroach/pkg/util/syncutil/singleflight/singleflight.go:118 +0x4c

Goroutine 1191 (running) created at:
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.(*conn).serveImpl()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/conn.go:314 +0x14c4
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.serveConn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/conn.go:167 +0x27b
  github.com/cockroachdb/cockroach/pkg/sql/pgwire.(*Server).ServeConn()
      /go/src/github.com/cockroachdb/cockroach/pkg/sql/pgwire/server.go:509 +0xc71
  github.com/cockroachdb/cockroach/pkg/server.(*Server).Start.func20.1()
      /go/src/github.com/cockroachdb/cockroach/pkg/server/server.go:1710 +0x1a0
  github.com/cockroachdb/cockroach/pkg/util/netutil.(*Server).ServeWith.func1()
      /go/src/github.com/cockroachdb/cockroach/pkg/util/netutil/net.go:139 +0x104
```

