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
RUN git reset --hard 7df48bee8829276b13ef52bff4e1c47b9d55cd7d

# Apply the revert patch to this bug
COPY ./bug_patch.diff google.golang.org/grpc/bug_patch.diff
RUN git apply google.golang.org/grpc/bug_patch.diff


# Build
RUN go test ./transport -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/google.golang.org/grpc/./transport
