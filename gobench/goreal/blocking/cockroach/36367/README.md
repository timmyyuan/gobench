
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[cockroach#36367]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[cockroach#36367]:(cockroach36367_test.go)
[patch]:https://github.com/cockroachdb/cockroach/pull/36367/files
[pull request]:https://github.com/cockroachdb/cockroach/pull/36367
 
## Description

Some description from developers or pervious reseachers

> The test was relying on the non-transactional Get winning the
  race against txn2's put. Otherwise, the Get would block on txn2
  to complete and would deadlock.

go-deadlock report a false positive because the inconsistent locking
already guarded by other synchronization operations that dominate it.

```
POTENTIAL DEADLOCK: Inconsistent locking. saw this ordering in one goroutine:
happened before
../../vendor/golang.org/x/net/trace/trace.go:416 trace.(*trace).Finish { tr.mu.RLock() // protects tr fields in Cond.match calls } <<<<<
../util/tracing/tracer_span.go:311 tracing.(*span).FinishWithOptions { s.netTr.Finish() }
../util/tracing/tracer_span.go:295 tracing.(*span).Finish { s.FinishWithOptions(opentracing.FinishOptions{}) }
../../vendor/github.com/grpc-ecosystem/grpc-opentracing/go/otgrpc/server.go:69 otgrpc.OpenTracingServerInterceptor.func1 { return resp, err }
../rpc/heartbeat.pb.go:226 rpc._Heartbeat_Ping_Handler { return interceptor(ctx, in, info, handler) }
../../vendor/google.golang.org/grpc/server.go:1012 grpc.(*Server).processUnaryRPC { reply, appErr := md.Handler(srv.server, ctx, df, s.opts.unaryInt) }
../../vendor/google.golang.org/grpc/server.go:1250 grpc.(*Server).handleStream { s.processUnaryRPC(t, stream, srv, md, trInfo) }
../../vendor/google.golang.org/grpc/server.go:681 grpc.(*Server).serveStreams.func1.1 { s.handleStream(st, stream, s.traceInfo(st, stream)) }

happened after
../../vendor/golang.org/x/net/trace/trace.go:604 trace.(*traceBucket).Add { b.mu.Lock() } <<<<<
../../vendor/golang.org/x/net/trace/trace.go:419 trace.(*trace).Finish { b.Add(tr) }
../util/tracing/tracer_span.go:311 tracing.(*span).FinishWithOptions { s.netTr.Finish() }
../util/tracing/tracer_span.go:295 tracing.(*span).Finish { s.FinishWithOptions(opentracing.FinishOptions{}) }
../../vendor/github.com/grpc-ecosystem/grpc-opentracing/go/otgrpc/server.go:69 otgrpc.OpenTracingServerInterceptor.func1 { return resp, err }
../rpc/heartbeat.pb.go:226 rpc._Heartbeat_Ping_Handler { return interceptor(ctx, in, info, handler) }
../../vendor/google.golang.org/grpc/server.go:1012 grpc.(*Server).processUnaryRPC { reply, appErr := md.Handler(srv.server, ctx, df, s.opts.unaryInt) }
../../vendor/google.golang.org/grpc/server.go:1250 grpc.(*Server).handleStream { s.processUnaryRPC(t, stream, srv, md, trInfo) }
../../vendor/google.golang.org/grpc/server.go:681 grpc.(*Server).serveStreams.func1.1 { s.handleStream(st, stream, s.traceInfo(st, stream)) }

in another goroutine: happened before
../../vendor/golang.org/x/net/trace/trace.go:604 trace.(*traceBucket).Add { b.mu.Lock() } <<<<<
../../vendor/golang.org/x/net/trace/trace.go:419 trace.(*trace).Finish { b.Add(tr) }
../util/tracing/tracer_span.go:311 tracing.(*span).FinishWithOptions { s.netTr.Finish() }
../util/tracing/tracer_span.go:295 tracing.(*span).Finish { s.FinishWithOptions(opentracing.FinishOptions{}) }
../../vendor/github.com/grpc-ecosystem/grpc-opentracing/go/otgrpc/server.go:69 otgrpc.OpenTracingServerInterceptor.func1 { return resp, err }
../rpc/heartbeat.pb.go:226 rpc._Heartbeat_Ping_Handler { return interceptor(ctx, in, info, handler) }
../../vendor/google.golang.org/grpc/server.go:1012 grpc.(*Server).processUnaryRPC { reply, appErr := md.Handler(srv.server, ctx, df, s.opts.unaryInt) }
../../vendor/google.golang.org/grpc/server.go:1250 grpc.(*Server).handleStream { s.processUnaryRPC(t, stream, srv, md, trInfo) }
../../vendor/google.golang.org/grpc/server.go:681 grpc.(*Server).serveStreams.func1.1 { s.handleStream(st, stream, s.traceInfo(st, stream)) }

happened after
../../vendor/golang.org/x/net/trace/trace.go:871 trace.(*trace).unref { tr.mu.RLock() } <<<<<
../../vendor/golang.org/x/net/trace/trace.go:613 trace.(*traceBucket).Add { b.buf[i].unref() }
../../vendor/golang.org/x/net/trace/trace.go:419 trace.(*trace).Finish { b.Add(tr) }
../util/tracing/tracer_span.go:311 tracing.(*span).FinishWithOptions { s.netTr.Finish() }
../util/tracing/tracer_span.go:295 tracing.(*span).Finish { s.FinishWithOptions(opentracing.FinishOptions{}) }
../../vendor/github.com/grpc-ecosystem/grpc-opentracing/go/otgrpc/server.go:69 otgrpc.OpenTracingServerInterceptor.func1 { return resp, err }
../rpc/heartbeat.pb.go:226 rpc._Heartbeat_Ping_Handler { return interceptor(ctx, in, info, handler) }
../../vendor/google.golang.org/grpc/server.go:1012 grpc.(*Server).processUnaryRPC { reply, appErr := md.Handler(srv.server, ctx, df, s.opts.unaryInt) }
../../vendor/google.golang.org/grpc/server.go:1250 grpc.(*Server).handleStream { s.processUnaryRPC(t, stream, srv, md, trInfo) }
../../vendor/google.golang.org/grpc/server.go:681 grpc.(*Server).serveStreams.func1.1 { s.handleStream(st, stream, s.traceInfo(st, stream)) }
```

## Backtrace

```
Too many goroutines, please see the source code or view the log files
```

