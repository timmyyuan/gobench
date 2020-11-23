FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes




WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard f5e6161e499b913f869204085d89f6a131f500bd

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN sed -i '158 igo test ./contrib/mesos/pkg/election -c -o /go/gobench.test' hack/test-go.sh && \
    sed -i '159 iexit 0' hack/test-go.sh && \
    sed -i '232,241d' hack/lib/golang.sh

# Build
RUN make test WHAT=./contrib/mesos/pkg/election

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./contrib/mesos/pkg/election
