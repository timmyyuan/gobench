FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Update development envirnoment
RUN apt update && apt install -y rsync



WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard 25074a190ef2a07d8b0ed38734f2cb373edfb868

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN sed -i '287 igo test ./pkg/credentialprovider/aws -race -c -o /go/gobench.test' hack/make-rules/test.sh && \
    sed -i '288 iexit 0' hack/make-rules/test.sh

# Build
RUN make test WHAT=./pkg/credentialprovider/aws

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/./pkg/credentialprovider/aws
