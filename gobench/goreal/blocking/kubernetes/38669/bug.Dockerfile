FROM golang:1.12
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Update development envirnoment
RUN apt update && apt install -y rsync



WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard f02c8e47bc41e76594aec1b4db80900e9a2a9a15

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN sed -i '169s/a)/a\.\.\.)/' pkg/storage/errors.go

# Build
RUN go test ./pkg/storage/ -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./pkg/storage
