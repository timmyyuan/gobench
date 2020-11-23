FROM golang:1.14
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/go.etcd.io/etcd




WORKDIR /go/src/go.etcd.io/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 3082a7d52119960a2bdc0c60566186c54df9bc35

# Apply the revert patch to this bug
COPY ./bug_patch.diff go.etcd.io/etcd/bug_patch.diff
RUN git apply go.etcd.io/etcd/bug_patch.diff

# Pred-build
RUN sed -i '159 igo test \${REPO_PATH}/integration -race -c -o /go/gobench.test' test && \
    sed -i '160 iexit 0' test

# Build
RUN VERBOSE=1 PKG=integration PASSES=integration TESTCASE=TestIssue2746WithThree ./test

# For entrypoint
WORKDIR /go/src/go.etcd.io/etcd/./integration
