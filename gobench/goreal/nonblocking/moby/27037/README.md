
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[moby#27037]|[pull request]|[patch]| NonBlocking | Go-Specific | Anonymous Function |

[moby#27037]:(moby27037_test.go)
[patch]:https://github.com/moby/moby/pull/27037/files
[pull request]:https://github.com/moby/moby/pull/27037
 

## Backtrace

```
Read at 0x00c4202f4018 by goroutine 27:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning.func1()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:176 +0xa8

Previous write at 0x00c4202f4018 by goroutine 22:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:172 +0x300
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 27 (running) created at:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:185 +0x2d6
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 22 (running) created at:
  github.com/go-check/check.(*suiteRunner).forkCall()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:673 +0x422
  github.com/go-check/check.(*suiteRunner).forkTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:850 +0x131
  github.com/go-check/check.(*suiteRunner).runTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:859 +0x97
  github.com/go-check/check.(*suiteRunner).run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:621 +0x1c5
  github.com/go-check/check.Run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:100 +0x5a
  github.com/go-check/check.RunAll()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:92 +0x112
  github.com/go-check/check.TestingT()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:80 +0x751
  github.com/docker/docker/integration-cli.Test()
      /go/src/github.com/docker/docker/integration-cli/check_test.go:29 +0x144
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:610 +0xc9
```

```
Read at 0x00c4202f4018 by goroutine 29:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning.func1()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:176 +0xa8

Previous write at 0x00c4202f4018 by goroutine 22:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:172 +0x300
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 29 (running) created at:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:185 +0x2d6
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 22 (running) created at:
  github.com/go-check/check.(*suiteRunner).forkCall()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:673 +0x422
  github.com/go-check/check.(*suiteRunner).forkTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:850 +0x131
  github.com/go-check/check.(*suiteRunner).runTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:859 +0x97
  github.com/go-check/check.(*suiteRunner).run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:621 +0x1c5
  github.com/go-check/check.Run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:100 +0x5a
  github.com/go-check/check.RunAll()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:92 +0x112
  github.com/go-check/check.TestingT()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:80 +0x751
  github.com/docker/docker/integration-cli.Test()
      /go/src/github.com/docker/docker/integration-cli/check_test.go:29 +0x144
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:610 +0xc9
```


```
Read at 0x00c4202f4018 by goroutine 30:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning.func1()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:176 +0xa8

Previous write at 0x00c4202f4018 by goroutine 22:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:172 +0x300
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 30 (running) created at:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:185 +0x2d6
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 22 (running) created at:
  github.com/go-check/check.(*suiteRunner).forkCall()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:673 +0x422
  github.com/go-check/check.(*suiteRunner).forkTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:850 +0x131
  github.com/go-check/check.(*suiteRunner).runTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:859 +0x97
  github.com/go-check/check.(*suiteRunner).run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:621 +0x1c5
  github.com/go-check/check.Run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:100 +0x5a
  github.com/go-check/check.RunAll()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:92 +0x112
  github.com/go-check/check.TestingT()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:80 +0x751
  github.com/docker/docker/integration-cli.Test()
      /go/src/github.com/docker/docker/integration-cli/check_test.go:29 +0x144
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:610 +0xc9
```

```
Read at 0x00c4202f4018 by goroutine 31:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning.func1()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:176 +0xa8

Previous write at 0x00c4202f4018 by goroutine 22:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:172 +0x300
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 31 (running) created at:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:185 +0x2d6
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 22 (running) created at:
  github.com/go-check/check.(*suiteRunner).forkCall()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:673 +0x422
  github.com/go-check/check.(*suiteRunner).forkTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:850 +0x131
  github.com/go-check/check.(*suiteRunner).runTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:859 +0x97
  github.com/go-check/check.(*suiteRunner).run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:621 +0x1c5
  github.com/go-check/check.Run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:100 +0x5a
  github.com/go-check/check.RunAll()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:92 +0x112
  github.com/go-check/check.TestingT()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:80 +0x751
  github.com/docker/docker/integration-cli.Test()
      /go/src/github.com/docker/docker/integration-cli/check_test.go:29 +0x144
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:610 +0xc9
```

```
Read at 0x00c4202f4018 by goroutine 28:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning.func1()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:176 +0xa8

Previous write at 0x00c4202f4018 by goroutine 22:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:172 +0x300
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 28 (running) created at:
  github.com/docker/docker/integration-cli.(*DockerSuite).TestAPIStatsNetworkStatsVersioning()
      /go/src/github.com/docker/docker/integration-cli/docker_api_stats_test.go:185 +0x2d6
  runtime.call32()
      /usr/local/go/src/runtime/asm_amd64.s:479 +0x4b
  reflect.Value.Call()
      /usr/local/go/src/reflect/value.go:302 +0xc0
  github.com/go-check/check.(*suiteRunner).forkTest.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:816 +0xab0
  github.com/go-check/check.(*suiteRunner).forkCall.func1()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:672 +0x89

Goroutine 22 (running) created at:
  github.com/go-check/check.(*suiteRunner).forkCall()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:673 +0x422
  github.com/go-check/check.(*suiteRunner).forkTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:850 +0x131
  github.com/go-check/check.(*suiteRunner).runTest()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:859 +0x97
  github.com/go-check/check.(*suiteRunner).run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/check.go:621 +0x1c5
  github.com/go-check/check.Run()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:100 +0x5a
  github.com/go-check/check.RunAll()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:92 +0x112
  github.com/go-check/check.TestingT()
      /go/src/github.com/docker/docker/vendor/src/github.com/go-check/check/run.go:80 +0x751
  github.com/docker/docker/integration-cli.Test()
      /go/src/github.com/docker/docker/integration-cli/check_test.go:29 +0x144
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:610 +0xc9
```