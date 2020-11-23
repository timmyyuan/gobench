FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 673c6f065080be10403515826e1c7f58c20dbcd3

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '83 igo test ./lease -race -c -o /go/gobench.test' test && \
    sed -i '84 iexit 0' test

# Build
RUN VERBOSE=1 PKG=./lease PASSES=unit TESTCASE=TestLessorRenewExtendPileup ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./lease
