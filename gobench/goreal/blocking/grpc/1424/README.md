
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#1424]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[grpc#1424]:(grpc1424_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/1424/files
[pull request]:https://github.com/grpc/grpc-go/pull/1424
 
## Description

Some description from developers or pervious reseachers

> A leak happens when DialContext times out before a balancer returns any
  addresses or before a successful connection is established.
  The loop in ClientConn.lbWatcher breaks and doneChan never gets closed.

See the [bug kernel](../../../../goker/blocking/grpc/1424/README.md)
