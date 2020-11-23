FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes




WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard d15de72a92c8841d069b1265e433eb52edc29822

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN sed -i '231,247d' hack/lib/golang.sh && \
    sed -i '204 igo test ./pkg/controller/framework -race -c -o /go/gobench.test' hack/test-go.sh && \
    sed -i '205 iexit 0' hack/test-go.sh

# Build
RUN make test WHAT=./pkg/controller/framework

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./pkg/controller/framework
