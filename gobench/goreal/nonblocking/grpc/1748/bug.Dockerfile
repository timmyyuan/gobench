FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/grpc/grpc-go.git /go/src/google.golang.org/grpc




# Download needed packages
RUN go get -v -d github.com/golang/glog && \
    go get -v -d github.com/golang/protobuf/proto && \
    go get -v -d github.com/golang/protobuf/ptypes && \
    go get -v -d golang.org/x/net/context && \
    go get -v -d golang.org/x/net/http2 && \
    go get -v -d golang.org/x/net/http2/hpack && \
    go get -v -d golang.org/x/net/trace && \
    go get -v -d google.golang.org/genproto/googleapis/rpc/status
WORKDIR /go/src/google.golang.org/grpc

# Rollback to the latest bug-free version
RUN git reset --hard 6610f9a3403d6e84b5a585fe27e00f9d7dffca6a

# Apply the revert patch to this bug
COPY ./bug_patch.diff google.golang.org/grpc/bug_patch.diff
RUN git apply google.golang.org/grpc/bug_patch.diff


# Build
RUN go test . -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/google.golang.org/grpc/.
