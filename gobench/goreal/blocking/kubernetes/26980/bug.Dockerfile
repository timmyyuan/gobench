FROM golang:1.12
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Update development envirnoment
RUN apt update && apt install -y rsync



WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard 628af356b8c83f98ee3b50dfcf8b0250816a5581

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff


# Build
RUN go test ./pkg/controller/framework -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./pkg/controller/framework
