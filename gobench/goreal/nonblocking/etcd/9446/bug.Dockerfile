FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 576a2ca501e95f7343df19ad1aa2183058440d57

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '133 igo test \${REPO_PATH}/integration -race -c -o /go/gobench.test' test && \
    sed -i '134 iexit 0' test

# Build
RUN VERBOSE=1 PKG=integration PASSES=integration TESTCASE=TestV3MaintenanceDefragmentInflightRange ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./integration
