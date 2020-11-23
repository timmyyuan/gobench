FROM golang:1.10
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 9ed3b446cadd9f43734d9eed9dcb03f3b12567a5

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '167s/fmt_tests/# fmt_tests/' test && \
    sed -i '170s/unit_tests/# unit_tests/' test && \
    sed -i '73,74d' test && \
    sed -i '72 igo test \${REPO_PATH}/clientv3/integration -c -o /go/gobench.test' test && \
    sed -i '73 iexit 0' test && \
    sed -i '66,71d' test

# Build
RUN INTEGRATION=1 ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./clientv3/integration
