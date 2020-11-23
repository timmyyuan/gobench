FROM golang:1.6
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard d533c14881d7b69d64047645816d56a61269b844

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '130d' test && \
    sed -i '127d' test && \
    sed -i '63 igo test \${REPO_PATH}/clientv3/integration -race -c -o /go/gobench.test' test && \
    sed -i '64 iexit 0' test && \
    sed -i '61,62d' test

# Build
RUN INTEGRATION=1 ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./clientv3/integration
