
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[serving#3148]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[serving#3148]:(serving3148_test.go)
[patch]:https://github.com/ knative/serving/pull/3148/files
[pull request]:https://github.com/ knative/serving/pull/3148
 

## Backtrace

```
Read at 0x00c0005d8cb0 by goroutine 146:
  github.com/knative/serving/vendor/k8s.io/client-go/testing.(*Fake).Invokes()
      /go/src/github.com/knative/serving/vendor/k8s.io/client-go/testing/fake.go:135 +0x1af
  github.com/knative/serving/pkg/client/clientset/versioned/typed/autoscaling/v1alpha1/fake.(*FakePodAutoscalers).Create()
      /go/src/github.com/knative/serving/pkg/client/clientset/versioned/typed/autoscaling/v1alpha1/fake/fake_podautoscaler.go:81 +0x290
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).createKPA()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/cruds.go:110 +0xfa
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcileKPA()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/reconcile_resources.go:131 +0xb51
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcileKPA-fm()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/reconcile_resources.go:122 +0x63
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcile()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision.go:402 +0x648
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).Reconcile()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision.go:267 +0x2f1
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).processNextWorkItem()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:271 +0x463
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).Run.func1()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:223 +0x62

Previous write at 0x00c0005d8cb0 by goroutine 38:
  github.com/knative/serving/pkg/reconciler/testing.(*Hooks).OnUpdate()
      /go/src/github.com/knative/serving/vendor/k8s.io/client-go/testing/fake.go:104 +0x2e5
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision.func8()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:763 +0xbb4
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:865 +0x163

Goroutine 146 (running) created at:
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).Run()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:221 +0x20b
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision.func7()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:750 +0x53
  github.com/knative/serving/vendor/golang.org/x/sync/errgroup.(*Group).Go.func1()
      /go/src/github.com/knative/serving/vendor/golang.org/x/sync/errgroup/errgroup.go:58 +0x64

Goroutine 38 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:916 +0x65a
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:757 +0x1327
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:865 +0x163
```

```
Read at 0x00c0007e2cf0 by goroutine 146:
  github.com/knative/serving/vendor/k8s.io/client-go/testing.(*SimpleReactor).Handles()
      /go/src/github.com/knative/serving/vendor/k8s.io/client-go/testing/fixture.go:474 +0x52
  github.com/knative/serving/vendor/k8s.io/client-go/testing.(*Fake).Invokes()
      /go/src/github.com/knative/serving/vendor/k8s.io/client-go/testing/fake.go:136 +0x22f
  github.com/knative/serving/pkg/client/clientset/versioned/typed/autoscaling/v1alpha1/fake.(*FakePodAutoscalers).Create()
      /go/src/github.com/knative/serving/pkg/client/clientset/versioned/typed/autoscaling/v1alpha1/fake/fake_podautoscaler.go:81 +0x290
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).createKPA()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/cruds.go:110 +0xfa
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcileKPA()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/reconcile_resources.go:131 +0xb51
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcileKPA-fm()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/reconcile_resources.go:122 +0x63
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcile()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision.go:402 +0x648
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).Reconcile()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision.go:267 +0x2f1
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).processNextWorkItem()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:271 +0x463
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).Run.func1()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:223 +0x62

Previous write at 0x00c0007e2cf0 by goroutine 38:
  github.com/knative/serving/pkg/reconciler/testing.(*Hooks).OnUpdate()
      /go/src/github.com/knative/serving/vendor/k8s.io/client-go/testing/fake.go:104 +0x14d
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision.func8()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:763 +0xbb4
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:865 +0x163

Goroutine 146 (running) created at:
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).Run()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:221 +0x20b
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision.func7()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:750 +0x53
  github.com/knative/serving/vendor/golang.org/x/sync/errgroup.(*Group).Go.func1()
      /go/src/github.com/knative/serving/vendor/golang.org/x/sync/errgroup/errgroup.go:58 +0x64

Goroutine 38 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:916 +0x65a
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:757 +0x1327
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:865 +0x163
```

```
Read at 0x00c000428d30 by goroutine 146:
  github.com/knative/serving/vendor/k8s.io/client-go/testing.(*Fake).Invokes()
      /go/src/github.com/knative/serving/vendor/k8s.io/client-go/testing/fake.go:135 +0x1f5
  github.com/knative/serving/pkg/client/clientset/versioned/typed/autoscaling/v1alpha1/fake.(*FakePodAutoscalers).Create()
      /go/src/github.com/knative/serving/pkg/client/clientset/versioned/typed/autoscaling/v1alpha1/fake/fake_podautoscaler.go:81 +0x290
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).createKPA()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/cruds.go:110 +0xfa
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcileKPA()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/reconcile_resources.go:131 +0xb51
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcileKPA-fm()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/reconcile_resources.go:122 +0x63
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).reconcile()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision.go:402 +0x648
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.(*Reconciler).Reconcile()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision.go:267 +0x2f1
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).processNextWorkItem()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:271 +0x463
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).Run.func1()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:223 +0x62

Previous write at 0x00c000428d30 by goroutine 38:
  runtime.slicecopy()
      /usr/local/go/src/runtime/slice.go:197 +0x0
  github.com/knative/serving/pkg/reconciler/testing.(*Hooks).OnUpdate()
      /go/src/github.com/knative/serving/vendor/k8s.io/client-go/testing/fake.go:104 +0x2d7
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision.func8()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:763 +0xbb4
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:865 +0x163

Goroutine 146 (running) created at:
  github.com/knative/serving/vendor/github.com/knative/pkg/controller.(*Impl).Run()
      /go/src/github.com/knative/serving/vendor/github.com/knative/pkg/controller/controller.go:221 +0x20b
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision.func7()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:750 +0x53
  github.com/knative/serving/vendor/golang.org/x/sync/errgroup.(*Group).Go.func1()
      /go/src/github.com/knative/serving/vendor/golang.org/x/sync/errgroup/errgroup.go:58 +0x64

Goroutine 38 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:916 +0x65a
  github.com/knative/serving/pkg/reconciler/v1alpha1/revision.TestGlobalResyncOnConfigMapUpdateRevision()
      /go/src/github.com/knative/serving/pkg/reconciler/v1alpha1/revision/revision_test.go:757 +0x1327
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:865 +0x163
```
