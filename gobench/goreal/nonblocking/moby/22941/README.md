
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[moby#22941]|[pull request]|[patch]| NonBlocking | Go-Specific | Anonymous Function |

[moby#22941]:(moby22941_test.go)
[patch]:https://github.com/moby/moby/pull/22941/files
[pull request]:https://github.com/moby/moby/pull/22941
 

## Backtrace

```
Read by goroutine 9:
  github.com/docker/docker/cmd/dockerd/hack.TestHeaderOverrideHack.func1()
      /go/src/github.com/docker/docker/cmd/dockerd/hack/malformed_host_override_test.go:42 +0x2e

Previous write by goroutine 6:
  github.com/docker/docker/cmd/dockerd/hack.TestHeaderOverrideHack()
      /go/src/github.com/docker/docker/cmd/dockerd/hack/malformed_host_override_test.go:40 +0xf3d
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc

Goroutine 9 (running) created at:
  github.com/docker/docker/cmd/dockerd/hack.TestHeaderOverrideHack()
      /go/src/github.com/docker/docker/cmd/dockerd/hack/malformed_host_override_test.go:43 +0xfa6
--- PASS: TestHeaderOverrideHack (0.00s)
PASS
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc

Goroutine 6 (finished) created at:
  testing.RunTests()
      /usr/local/go/src/testing/testing.go:561 +0xaa3
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:494 +0xe4
  main.main()
      github.com/docker/docker/cmd/dockerd/hack/_test/_testmain.go:58 +0x20f
```

