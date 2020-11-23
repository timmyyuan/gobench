FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes




WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard 9c25792dca98c8ae798a2c0763c1a08934fe567c

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN sed -i '147 igo test "\${pkg}" -c -o /go/gobench.test' hack/test-go.sh && \
    sed -i '148 iexit 0' hack/test-go.sh && \
    sed -i '130,135d' hack/config-go.sh

# Build
RUN make test WHAT=./pkg/watch

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./pkg/watch
