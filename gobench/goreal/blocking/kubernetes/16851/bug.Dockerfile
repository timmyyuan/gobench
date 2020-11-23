FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Update development envirnoment
RUN apt update && apt install -y rsync



WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard 919d2c11260f762a27c8918ea8375aa4a7dc873c

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN sed -i '235,251d' hack/lib/golang.sh && \
    sed -i '232 igo test ./contrib/mesos/pkg/scheduler -c -o /go/gobench.test' hack/test-go.sh && \
    sed -i '233 iexit 0' hack/test-go.sh && \
    sed -i '809d' contrib/mesos/pkg/scheduler/plugin.go && \
    sed -i '464d' contrib/mesos/pkg/scheduler/scheduler.go

# Build
RUN make test WHAT=./contrib/mesos/pkg/scheduler

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./contrib/mesos/pkg/scheduler
