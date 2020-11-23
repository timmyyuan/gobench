
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[kubernetes#82239]|[pull request]|[patch]| NonBlocking | Traditional | Data Race |

[kubernetes#82239]:(kubernetes82239_test.go)
[patch]:https://github.com/kubernetes/kubernetes/pull/82239/files
[pull request]:https://github.com/kubernetes/kubernetes/pull/82239
 

## Backtrace

```
Write at 0x00c000658810 by goroutine 113:
  runtime.mapassign_faststr()
      /usr/local/go/src/runtime/map_faststr.go:202 +0x0
  k8s.io/kubernetes/pkg/controller/volume/persistentvolume.TestControllerSync.func4()
      /go/src/k8s.io/kubernetes/pkg/controller/volume/persistentvolume/pv_controller_test.go:120 +0xaa
  k8s.io/kubernetes/pkg/controller/volume/persistentvolume.TestControllerSync()
      /go/src/k8s.io/kubernetes/pkg/controller/volume/persistentvolume/pv_controller_test.go:291 +0x2dd0
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199

Previous read at 0x00c000658810 by goroutine 60:
  runtime.mapaccess2_faststr()
      /usr/local/go/src/runtime/map_faststr.go:107 +0x0
  k8s.io/kubernetes/pkg/controller/volume/persistentvolume.(*PersistentVolumeController).syncVolume()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/apis/meta/v1/helpers.go:192 +0x38d9
  k8s.io/kubernetes/pkg/controller/volume/persistentvolume.(*PersistentVolumeController).updateVolume()
      /go/src/k8s.io/kubernetes/pkg/controller/volume/persistentvolume/pv_controller_base.go:197 +0x181
  k8s.io/kubernetes/pkg/controller/volume/persistentvolume.(*PersistentVolumeController).volumeWorker.func1()
      /go/src/k8s.io/kubernetes/pkg/controller/volume/persistentvolume/pv_controller_base.go:321 +0x8c0
  k8s.io/kubernetes/pkg/controller/volume/persistentvolume.(*PersistentVolumeController).volumeWorker()
      /go/src/k8s.io/kubernetes/pkg/controller/volume/persistentvolume/pv_controller_base.go:351 +0x58
  k8s.io/kubernetes/pkg/controller/volume/persistentvolume.(*PersistentVolumeController).volumeWorker-fm()
      /go/src/k8s.io/kubernetes/pkg/controller/volume/persistentvolume/pv_controller_base.go:302 +0x41
  k8s.io/apimachinery/pkg/util/wait.JitterUntil.func1()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:152 +0x6f
  k8s.io/apimachinery/pkg/util/wait.JitterUntil()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:153 +0x108
  k8s.io/apimachinery/pkg/util/wait.Until()
      /go/src/k8s.io/kubernetes/staging/src/k8s.io/apimachinery/pkg/util/wait/wait.go:88 +0x5a

Goroutine 113 (running) created at:
  testing.(*T).Run()
      /usr/local/go/src/testing/testing.go:960 +0x651
  testing.runTests.func1()
      /usr/local/go/src/testing/testing.go:1202 +0xa6
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:909 +0x199
  testing.runTests()
      /usr/local/go/src/testing/testing.go:1200 +0x521
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:1117 +0x2ff
  main.main()
      _testmain.go:96 +0x223
```

