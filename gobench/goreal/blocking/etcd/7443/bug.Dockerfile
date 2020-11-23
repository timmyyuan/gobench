FROM golang:1.10
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 0a692b0524625996e48f5d3a47cfeac7fe9cc759

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '72 igo test ./clientv3 -c -o /go/gobench.test' test && \
    sed -i '73 iexit 0' test

# Build
RUN PKG=./clientv3 PASSES='build unit' ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./clientv3
