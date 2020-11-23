FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Update development envirnoment
RUN apt update && apt install -y rsync



WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard 5257266e9be5e757842d7d4e98b4942f90235b8b

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff


# Build
RUN go test ./pkg/scheduler/internal/queue -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./pkg/scheduler/internal/queue
