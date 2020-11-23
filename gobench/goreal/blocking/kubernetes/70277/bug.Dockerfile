FROM golang:1.12
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Update development envirnoment
RUN apt update && apt install -y rsync



WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard 81a1f12dab66688568fc75d1dd84f769f433e2ee

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN cp -r ./vendor/* /go/src/ && \
    rm -rf /go/src/k8s.io/apimachinery && \
    cp -r ./staging/src/k8s.io/apimachinery /go/src/k8s.io/

# Build
RUN go test ../apimachinery/pkg/util/wait -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/../apimachinery/pkg/util/wait
