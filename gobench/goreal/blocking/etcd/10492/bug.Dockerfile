FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 4b69cfc56b070456cefabea86e57f9ccd1ab09a2

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '135 igo test ./lease -c -o /go/gobench.test' test && \
    sed -i '136 iexit 0' test

# Build
RUN VERBOSE=1 PKG=./lease PASSES='unit' ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./lease
