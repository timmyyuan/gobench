
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#1859]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[grpc#1859]:(grpc1859_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/1859/files
[pull request]:https://github.com/grpc/grpc-go/pull/1859
 
## Description

Some description from developers or pervious reseachers

> Fix deadlock: In case of an error while writing, add transport quota back


This is a [example](https://github.com/dim13/grpc_deadlock) to trigger the deadlock

## Backtrace

Too many goroutines, please see this [comment](https://github.com/grpc/grpc-go/issues/1850#issuecomment-365718753) in the [issues](https://github.com/grpc/grpc-go/issues/1850)

