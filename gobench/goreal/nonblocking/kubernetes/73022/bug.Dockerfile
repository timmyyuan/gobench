FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Update development envirnoment
RUN apt update && apt install -y rsync



WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard c999dc3854d7b14aa28b7c61622a8bc2975e5367

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN sed -i '286 igo test ./pkg/scheduler/internal/queue -race -c -o /go/gobench.test' hack/make-rules/test.sh && \
    sed -i '287 iexit 0' hack/make-rules/test.sh

# Build
RUN make test WHAT=./pkg/scheduler/internal/queue

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./pkg/scheduler/internal/queue
