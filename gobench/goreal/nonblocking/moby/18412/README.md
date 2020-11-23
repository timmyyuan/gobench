
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[moby#18412]|[pull request]|[patch]| NonBlocking | Traditional | Order Violation |

[moby#18412]:(moby18412_test.go)
[patch]:https://github.com/moby/moby/pull/18412/files
[pull request]:https://github.com/moby/moby/pull/18412
 

## Backtrace

```
Read by goroutine 6:
  github.com/docker/docker/pkg/integration.RunCommandWithOutputForDuration()
      /go/src/github.com/docker/docker/pkg/integration/utils.go:133 +0x9f6
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc

Previous write by goroutine 7:
  bytes.(*Buffer).Truncate()
      /usr/local/go/src/bytes/buffer.go:72 +0xb5
  bytes.(*Buffer).ReadFrom()
      /usr/local/go/src/bytes/buffer.go:158 +0xcd
  io.copyBuffer()
      /usr/local/go/src/io/io.go:375 +0x1a5
  io.Copy()
      /usr/local/go/src/io/io.go:351 +0x78
  os/exec.(*Cmd).writerDescriptor.func1()
      /usr/local/go/src/os/exec/exec.go:232 +0x98
  os/exec.(*Cmd).Start.func1()
      /usr/local/go/src/os/exec/exec.go:340 +0x2a

Goroutine 6 (running) created at:
  testing.RunTests()
      /usr/local/go/src/testing/testing.go:561 +0xaa3
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:494 +0xe4
  main.main()
      github.com/docker/docker/pkg/integration/_test/_testmain.go:110 +0x20f

Goroutine 7 (running) created at:
  os/exec.(*Cmd).Start()
      /usr/local/go/src/os/exec/exec.go:341 +0xe4e
  github.com/docker/docker/pkg/integration.RunCommandWithOutputForDuration()
      /go/src/github.com/docker/docker/pkg/integration/utils.go:110 +0x4dc
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc
```

```
Read by goroutine 6:
  github.com/docker/docker/pkg/integration.RunCommandWithOutputForDuration()
      /go/src/github.com/docker/docker/pkg/integration/utils.go:133 +0xa0d
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc

Previous write by goroutine 7:
  bytes.(*Buffer).Truncate()
      /usr/local/go/src/bytes/buffer.go:74 +0xef
  bytes.(*Buffer).ReadFrom()
      /usr/local/go/src/bytes/buffer.go:158 +0xcd
  io.copyBuffer()
      /usr/local/go/src/io/io.go:375 +0x1a5
  io.Copy()
      /usr/local/go/src/io/io.go:351 +0x78
  os/exec.(*Cmd).writerDescriptor.func1()
      /usr/local/go/src/os/exec/exec.go:232 +0x98
  os/exec.(*Cmd).Start.func1()
      /usr/local/go/src/os/exec/exec.go:340 +0x2a

Goroutine 6 (running) created at:
  testing.RunTests()
      /usr/local/go/src/testing/testing.go:561 +0xaa3
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:494 +0xe4
  main.main()
      github.com/docker/docker/pkg/integration/_test/_testmain.go:110 +0x20f

Goroutine 7 (running) created at:
  os/exec.(*Cmd).Start()
      /usr/local/go/src/os/exec/exec.go:341 +0xe4e
  github.com/docker/docker/pkg/integration.RunCommandWithOutputForDuration()
      /go/src/github.com/docker/docker/pkg/integration/utils.go:110 +0x4dc
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc
```

```
Read by goroutine 6:
  runtime.slicebytetostring()
      /usr/local/go/src/runtime/string.go:75 +0x0
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc

Previous write by goroutine 7:
  runtime.slicecopy()
      /usr/local/go/src/runtime/slice.go:110 +0x0
  bytes.(*Buffer).ReadFrom()
      /usr/local/go/src/bytes/buffer.go:169 +0x27f
  io.copyBuffer()
      /usr/local/go/src/io/io.go:375 +0x1a5
  io.Copy()
      /usr/local/go/src/io/io.go:351 +0x78
  os/exec.(*Cmd).writerDescriptor.func1()
      /usr/local/go/src/os/exec/exec.go:232 +0x98
  os/exec.(*Cmd).Start.func1()
      /usr/local/go/src/os/exec/exec.go:340 +0x2a

Goroutine 6 (running) created at:
  testing.RunTests()
      /usr/local/go/src/testing/testing.go:561 +0xaa3
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:494 +0xe4
  main.main()
      github.com/docker/docker/pkg/integration/_test/_testmain.go:110 +0x20f

Goroutine 7 (running) created at:
  os/exec.(*Cmd).Start()
      /usr/local/go/src/os/exec/exec.go:341 +0xe4e
  github.com/docker/docker/pkg/integration.RunCommandWithOutputForDuration()
      /go/src/github.com/docker/docker/pkg/integration/utils.go:110 +0x4dc
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc
```

```
Read by goroutine 6:
  runtime.slicebytetostring()
      /usr/local/go/src/runtime/string.go:75 +0x0
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc

Previous write by goroutine 7:
  syscall.raceWriteRange()
      /usr/local/go/src/syscall/race.go:29 +0x38
  syscall.Read()
      /usr/local/go/src/syscall/syscall_unix.go:163 +0x9d
  os.(*File).read()
      /usr/local/go/src/os/file_unix.go:211 +0x89
  os.(*File).Read()
      /usr/local/go/src/os/file.go:95 +0xbc
  bytes.(*Buffer).ReadFrom()
      /usr/local/go/src/bytes/buffer.go:173 +0x414
  io.copyBuffer()
      /usr/local/go/src/io/io.go:375 +0x1a5
  io.Copy()
      /usr/local/go/src/io/io.go:351 +0x78
  os/exec.(*Cmd).writerDescriptor.func1()
      /usr/local/go/src/os/exec/exec.go:232 +0x98
  os/exec.(*Cmd).Start.func1()
      /usr/local/go/src/os/exec/exec.go:340 +0x2a

Goroutine 6 (running) created at:
  testing.RunTests()
      /usr/local/go/src/testing/testing.go:561 +0xaa3
  testing.(*M).Run()
      /usr/local/go/src/testing/testing.go:494 +0xe4
  main.main()
      github.com/docker/docker/pkg/integration/_test/_testmain.go:110 +0x20f

Goroutine 7 (running) created at:
  os/exec.(*Cmd).Start()
      /usr/local/go/src/os/exec/exec.go:341 +0xe4e
  github.com/docker/docker/pkg/integration.RunCommandWithOutputForDuration()
      /go/src/github.com/docker/docker/pkg/integration/utils.go:110 +0x4dc
  github.com/docker/docker/pkg/integration.TestRunCommandWithOutputForDurationKilled()
      /go/src/github.com/docker/docker/pkg/integration/utils_test.go:109 +0xf5
  testing.tRunner()
      /usr/local/go/src/testing/testing.go:456 +0xdc
```