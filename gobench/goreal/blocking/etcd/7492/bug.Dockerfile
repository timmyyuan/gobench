FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 148c923c72c4aa9207173c03b775e2c0b8754067

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '72 igo test ./auth -c -o /go/gobench.test' test && \
    sed -i '73 iexit 0' test

# Build
RUN PKG=./auth PASSES='build unit' ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./auth
