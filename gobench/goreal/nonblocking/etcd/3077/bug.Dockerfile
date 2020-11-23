FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd




WORKDIR /go/src/github.com/coreos/etcd

# Rollback to the latest bug-free version
RUN git reset --hard 5be545b872a5a5938f9664668c0022ca877c5439

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/coreos/etcd/bug_patch.diff
RUN git apply github.com/coreos/etcd/bug_patch.diff

# Pred-build
RUN sed -i '17s/GitSHA /GitSHA=/' build && \
    sed -i '47 igo test ./etcdserver -race -c -o \/go\/gobench.test' test && \
    sed -i '48 iexit 0' test

# Build
RUN ./test

# For entrypoint
WORKDIR /go/src/github.com/coreos/etcd/./etcdserver
