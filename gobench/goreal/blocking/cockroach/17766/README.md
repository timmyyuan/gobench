
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#17766]|[pull request]|[patch]| Blocking | Mixed Deadlock | Channel & Lock |

[cockroach#17766]:(cockroach17766_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/17766/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/17766
 
## Description

Some description from developers or pervious reseachers

> Looks like we have a deadlock scenario:
> 1. DistSender needs to refresh the range descriptor cache and calls 
>    RangeDescriptorCache.lookupRangeDescriptorInternal which adds a note that 
>    there is a pending lookup operation.
> 2. The RangeLookup finds an intent and calls IntentResolver.processIntentsAsync. 
>    There are too many async tasks already running, so it uses the current goroutine 
>    to process the intent resolution.
> 3. Resolving the intent involves trying to push the transaction which requires a 
>    DistSender call which requires looking up the range descriptor we're currently trying 
>    to resolve which blocks forever waiting for the prior request to finish.
  
> Note that performing intent resolution on the calling goroutine when there are no async 
tasks available was a necessary feedback loop. Prior to adding it, we were seeing a spike 
in intent resolution goroutines under certain scenarios. One possible hacky workaround 
would be to not perform the intent resolution synchronously for RangeLookup operations.

go-deadlock report a false positive because the inconsistent locking
already guarded by other synchronization operations that dominate it.

```
POTENTIAL DEADLOCK: Inconsistent locking. saw this ordering in one goroutine:
happened before
../util/syncutil/mutex_sync.go:33 syncutil.(*Mutex).Lock { m.mu.Lock() } <<<<<
timedmutex.go:92 storage.(*timedMutex).Lock { tm.mu.Lock() }
replica.go:3113 storage.(*Replica).handleRaftReady { r.raftMu.Lock() }
store.go:3537 storage.(*Store).processReady { stats, err := r.handleRaftReady(IncomingSnapshot{}) }
scheduler.go:216 storage.(*raftScheduler).worker { s.processor.processReady(ctx, id) }
scheduler.go:167 storage.(*raftScheduler).Start.func2 { s.worker(ctx) }
../util/stop/stopper.go:197 stop.(*Stopper).RunWorker.func1 { f(ctx) }

happened after
../util/syncutil/mutex_sync.go:69 syncutil.(*RWMutex).Lock { m.RWMutex.Lock() } <<<<<
replica_proposal.go:660 storage.(*Replica).handleReplicatedEvalResult { r.readOnlyCmdMu.Lock() }
replica_proposal.go:972 storage.(*Replica).handleEvalResultRaftMuLocked { shouldAssert := r.handleReplicatedEvalResult(ctx, rResult) }
replica.go:4297 storage.(*Replica).processRaftCommand { r.handleEvalResultRaftMuLocked(ctx, lResult, raftCmd.ReplicatedEvalResult) }
replica.go:3401 storage.(*Replica).handleRaftReadyRaftMuLocked { if changedRepl := r.processRaftCommand(ctx, commandID, e.Term, e.Index, command); changedRepl { }
replica.go:3115 storage.(*Replica).handleRaftReady { return r.handleRaftReadyRaftMuLocked(inSnap) }
store.go:3537 storage.(*Store).processReady { stats, err := r.handleRaftReady(IncomingSnapshot{}) }
scheduler.go:216 storage.(*raftScheduler).worker { s.processor.processReady(ctx, id) }
scheduler.go:167 storage.(*raftScheduler).Start.func2 { s.worker(ctx) }
../util/stop/stopper.go:197 stop.(*Stopper).RunWorker.func1 { f(ctx) }

in another goroutine: happened before
replica.go:2381 storage.(*Replica).executeReadOnlyBatch { r.readOnlyCmdMu.RLock() } <<<<<
replica.go:1703 storage.(*Replica).Send { br, pErr = r.executeReadOnlyBatch(ctx, ba) }
../internal/client/sender.go:86 client.Wrap.func1 { return sender.Send(ctx, f(ba)) }
../internal/client/sender.go:48 client.SenderFunc.Send { return f(ctx, ba) }
../internal/client/sender.go:62 client.SendWrappedWith { br, pErr := sender.Send(ctx, ba) }
replica_test.go:246 storage.(*testContext).SendWrappedWith { return client.SendWrappedWith(context.Background(), tc.Sender(), h, args) }
replica_test.go:5785 storage.TestRangeLookupAsyncResolveIntent { reply, pErr = tc.SendWrappedWith(roachpb.Header{ }

happened after
../util/syncutil/mutex_sync.go:33 syncutil.(*Mutex).Lock { m.mu.Lock() } <<<<<
timedmutex.go:92 storage.(*timedMutex).Lock { tm.mu.Lock() }
replica.go:2888 storage.(*Replica).propose { r.raftMu.Lock() }
replica.go:2587 storage.(*Replica).tryExecuteWriteBatch { ch, tryAbandon, undoQuotaAcquisition, pErr := r.propose(ctx, lease, ba, endCmds, spans) }
replica.go:2441 storage.(*Replica).executeWriteBatch { br, pErr, retry := r.tryExecuteWriteBatch(ctx, ba) }
replica.go:1700 storage.(*Replica).Send { br, pErr = r.executeWriteBatch(ctx, ba) }
store.go:2562 storage.(*Store).Send { br, pErr = repl.Send(ctx, ba) }
store_test.go:102 storage.(*testSender).Send { br, pErr := db.store.Send(ctx, ba) }
../internal/client/db.go:554 client.(*DB).send { br, pErr := db.sender.Send(ctx, ba) }
../internal/client/db.go:491 client.send)-fm { return sendAndFill(ctx, db.send, b) }
../internal/client/db.go:463 client.sendAndFill { b.response, b.pErr = send(ctx, ba) }
../internal/client/db.go:491 client.(*DB).Run { return sendAndFill(ctx, db.send, b) }
intent_resolver.go:210 storage.(*intentResolver).maybePushTransactions { if err := ir.store.db.Run(ctx, b); err != nil { }
intent_resolver.go:294 storage.(*intentResolver).processIntents { resolveIntents, pushErr := ir.maybePushTransactions(ctxWithTimeout, }
intent_resolver.go:273 storage.(*intentResolver).processIntentsAsync { ir.processIntents(ctx, r, item, now) }
replica.go:2416 storage.(*Replica).executeReadOnlyBatch { r.store.intentResolver.processIntentsAsync(r, intents) }
replica.go:1703 storage.(*Replica).Send { br, pErr = r.executeReadOnlyBatch(ctx, ba) }
../internal/client/sender.go:86 client.Wrap.func1 { return sender.Send(ctx, f(ba)) }
../internal/client/sender.go:48 client.SenderFunc.Send { return f(ctx, ba) }
../internal/client/sender.go:62 client.SendWrappedWith { br, pErr := sender.Send(ctx, ba) }
replica_test.go:246 storage.(*testContext).SendWrappedWith { return client.SendWrappedWith(context.Background(), tc.Sender(), h, args) }
replica_test.go:5785 storage.TestRangeLookupAsyncResolveIntent { reply, pErr = tc.SendWrappedWith(roachpb.Header{ }
``` 

## Backtrace

```
Too many goroutines, please see the source code or view the log files
```

