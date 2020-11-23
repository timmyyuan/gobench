
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[syncthing#5795]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[syncthing#5795]:(syncthing5795_test.go)
[patch]:https://github.com/syncthing/syncthing/pull/5795/files
[pull request]:https://github.com/syncthing/syncthing/pull/5795
 
## Description

Some description from developers or pervious reseachers
 
> 1. clusterconfig receiver updates config and waits for config to commit
> 2. config committer closes connections as part of commit, and waits for that
> 3. connection that is being closed waits for the dispatcher loop to exit
> 4. the dispatcher loop is busy calling clusterconfig in step one

See the [bug kernel](../../../../goker/blocking/syncthing/5795/README.md)

## Backtrace

```
goroutine 31 [semacquire]:
sync.runtime_Semacquire(0xc000036748)
        /usr/local/go/src/runtime/sema.go:56 +0x39
sync.(*WaitGroup).Wait(0xc000036740)
        /usr/local/go/src/sync/waitgroup.go:130 +0x65
github.com/syncthing/syncthing/lib/model.(*model).handleAutoAccepts(0xc0001aa160, 0xb6e7244db96f5164, 0xffaeeb46980dd237, 0x27c86839ef5695b0, 0xc244c124fec3ef6f, 0xc0000cc8c0, 0x2, 0xc00014c510, 0x1, 0x1, ...)
        /go/src/github.com/syncthing/syncthing/lib/model/model.go:1350 +0xa88
github.com/syncthing/syncthing/lib/model.(*model).ClusterConfig(0xc0001aa160, 0xb6e7244db96f5164, 0xffaeeb46980dd237, 0x27c86839ef5695b0, 0xc244c124fec3ef6f, 0xc00039e080, 0x2, 0x2)
        /go/src/github.com/syncthing/syncthing/lib/model/model.go:1053 +0x406
github.com/syncthing/syncthing/lib/protocol.(*rawConnection).dispatcherLoop(0xc0000fc410, 0x0, 0x0)
        /go/src/github.com/syncthing/syncthing/lib/protocol/protocol.go:407 +0x116e
github.com/syncthing/syncthing/lib/protocol.(*rawConnection).Start.func1(0xc0000fc410)
        /go/src/github.com/syncthing/syncthing/lib/protocol/protocol.go:255 +0x2b
created by github.com/syncthing/syncthing/lib/protocol.(*rawConnection).Start
        /go/src/github.com/syncthing/syncthing/lib/protocol/protocol.go:254 +0x65

goroutine 181 [chan receive]:
github.com/syncthing/syncthing/lib/protocol.(*rawConnection).internalClose.func1()
        /go/src/github.com/syncthing/syncthing/lib/protocol/protocol.go:903 +0x1de
sync.(*Once).Do(0xc0000fc4b8, 0xc001f04400)
        /usr/local/go/src/sync/once.go:44 +0xb3
github.com/syncthing/syncthing/lib/protocol.(*rawConnection).internalClose(0xc0000fc410, 0x4c3d2a0, 0xc00023a3a0)
        /go/src/github.com/syncthing/syncthing/lib/protocol/protocol.go:890 +0x6f
github.com/syncthing/syncthing/lib/protocol.(*rawConnection).Close(0xc0000fc410, 0x4c3d2a0, 0xc00023a3a0)
        /go/src/github.com/syncthing/syncthing/lib/protocol/protocol.go:885 +0x96
github.com/syncthing/syncthing/lib/connections.completeConn.Close(0x4c58320, 0xc000296a80, 0x3, 0xa, 0x4c5b940, 0xc00025c3c0, 0x4c3d2a0, 0xc00023a3a0)
        /go/src/github.com/syncthing/syncthing/lib/connections/structs.go:43 +0x45
github.com/syncthing/syncthing/lib/model.(*model).closeConns(0xc0001aa160, 0xc00043c400, 0x2, 0x2, 0x4c3d2a0, 0xc00023a3a0)
        /go/src/github.com/syncthing/syncthing/lib/model/model.go:1440 +0x23a
github.com/syncthing/syncthing/lib/model.(*model).startFolderLocked(0xc0001aa160, 0xc000226020, 0x7, 0x0, 0x0, 0x0, 0xc000036330, 0x9, 0x0, 0xc001ed2480, ...)
        /go/src/github.com/syncthing/syncthing/lib/model/model.go:285 +0x41e
github.com/syncthing/syncthing/lib/model.(*model).StartFolder(0xc0001aa160, 0xc000226020, 0x7)
        /go/src/github.com/syncthing/syncthing/lib/model/model.go:251 +0x14a
github.com/syncthing/syncthing/lib/model.(*model).CommitConfiguration(0xc0001aa160, 0x1d, 0x5292c28, 0x0, 0x0, 0xc001ee8500, 0x5, 0x5, 0x1, 0xc0000ccd30, ...)
        /go/src/github.com/syncthing/syncthing/lib/model/model.go:2478 +0x563
github.com/syncthing/syncthing/lib/config.(*wrapper).notifyListener(0xc0000a8800, 0x4c4d580, 0xc0001aa160, 0x1d, 0x5292c28, 0x0, 0x0, 0xc001ee8500, 0x5, 0x5, ...)
        /go/src/github.com/syncthing/syncthing/lib/config/wrapper.go:239 +0x154
github.com/syncthing/syncthing/lib/config.(*wrapper).notifyListeners.func1(0xc0000a8800, 0xc000297500, 0xc000297880, 0x4c4e400, 0xc000036740, 0x4c4d580, 0xc0001aa160)
        /go/src/github.com/syncthing/syncthing/lib/config/wrapper.go:230 +0x121
created by github.com/syncthing/syncthing/lib/config.(*wrapper).notifyListeners
        /go/src/github.com/syncthing/syncthing/lib/config/wrapper.go:229 +0x1bf
```

