
# GoReal

| Bug ID|  Ref | Patch | Type | SubType | SubsubType |
| ----  | ---- | ----  | ---- | ---- | ---- |
|[grpc#2391]|[pull request]|[patch]| Blocking | Communication Deadlock | Channel |

[grpc#2391]:(grpc2391_test.go)
[patch]:https://github.com/grpc/grpc-go/pull/2391/files
[pull request]:https://github.com/grpc/grpc-go/pull/2391
 
## Description

Some description from developers or pervious reseachers

> A deadlock can occur when a GO_AWAY is followed by a connection closure. This
  happens because onClose needlessly closes the current ac.transport: if a
  GO_AWAY already occured, and the transport was already reset, then the later
  closure (of the original address) sets ac.transport - which is now healthy -
  to nil.
