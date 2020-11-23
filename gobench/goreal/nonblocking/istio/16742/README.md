
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[istio#16742]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[istio#16742]:(istio16742_test.go)
[patch]:https://github.com/istio/istio/pull/16742/files
[pull request]:https://github.com/istio/istio/pull/16742
 

## Backtrace

```
Read at 0x00c000d3c5e0 by goroutine 115:
  istio.io/istio/pilot/pkg/networking/core/v1alpha3.(*ConfigGeneratorImpl).buildSidecarOutboundHTTPRouteConfig()
      /go/src/istio.io/istio/pilot/pkg/networking/core/v1alpha3/httproute.go:162 +0x6d3
  istio.io/istio/pilot/pkg/networking/core/v1alpha3.(*ConfigGeneratorImpl).BuildHTTPRoutes()
      /go/src/istio.io/istio/pilot/pkg/networking/core/v1alpha3/httproute.go:48 +0x14a
  istio.io/istio/pilot/pkg/proxy/envoy/v2.(*DiscoveryServer).generateRawRoutes()
      /go/src/istio.io/istio/pilot/pkg/proxy/envoy/v2/rds.go:59 +0x238
  istio.io/istio/pilot/pkg/proxy/envoy/v2.(*DiscoveryServer).pushRoute()
      /go/src/istio.io/istio/pilot/pkg/proxy/envoy/v2/rds.go:30 +0x6a
  istio.io/istio/pilot/pkg/proxy/envoy/v2.(*DiscoveryServer).StreamAggregatedResources()
      /go/src/istio.io/istio/pilot/pkg/proxy/envoy/v2/ads.go:374 +0x3389
  github.com/envoyproxy/go-control-plane/envoy/service/discovery/v2._AggregatedDiscoveryService_StreamAggregatedResources_Handler()
      /go/pkg/mod/github.com/envoyproxy/go-control-plane@v0.8.6/envoy/service/discovery/v2/ads.pb.go:195 +0xcd
  google.golang.org/grpc.(*Server).processStreamingRPC()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/server.go:1199 +0x1521
  google.golang.org/grpc.(*Server).handleStream()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/server.go:1279 +0x12d7
  google.golang.org/grpc.(*Server).serveStreams.func1.1()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/server.go:710 +0xc8

Previous write at 0x00c000d3c5e0 by goroutine 80:
  istio.io/istio/pilot/pkg/proxy/envoy/v2.(*DiscoveryServer).WorkloadUpdate()
      /go/src/istio.io/istio/pilot/pkg/proxy/envoy/v2/eds.go:469 +0x43f
  istio.io/istio/pilot/pkg/proxy/envoy/v2_test.TestLDSWithWorkloadLabelUpdate.func1()
      /go/src/istio.io/istio/pilot/pkg/proxy/envoy/v2/mem.go:111 +0x562
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Goroutine 115 (running) created at:
  google.golang.org/grpc.(*Server).serveStreams.func1()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/server.go:708 +0xb8
  google.golang.org/grpc/internal/transport.(*http2Server).operateHeaders()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/internal/transport/http2_server.go:429 +0x1679
  google.golang.org/grpc/internal/transport.(*http2Server).HandleStreams()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/internal/transport/http2_server.go:470 +0x3d7
  google.golang.org/grpc.(*Server).serveStreams()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/server.go:706 +0x19a
  google.golang.org/grpc.(*Server).handleRawConn.func1()
      /go/pkg/mod/google.golang.org/grpc@v1.23.0/server.go:668 +0x4c

Goroutine 80 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:960 +0x651
  istio.io/istio/pilot/pkg/proxy/envoy/v2_test.TestLDSWithWorkloadLabelUpdate()
      /go/src/istio.io/istio/pilot/pkg/proxy/envoy/v2/lds_test.go:551 +0x373
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
```

