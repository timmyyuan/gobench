FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




# Download needed packages
RUN go get -v -d github.com/ugorji/go/codec && \
    go get -v -d golang.org/x/net/context
WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 4f60f1b71f8608bc6f5c2a3296561cbc16d94d12

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN cd /go/src/github.com/ugorji/go/codec && \
    git reset --hard faddd6128c66c4708f45fdc007f575f75e592a3c

# Build
RUN cd /go/src/github.com/coreos/etcd && \
    go test ./client -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./client
