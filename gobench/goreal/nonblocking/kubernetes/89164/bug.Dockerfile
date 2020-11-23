FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes




WORKDIR /go/src/k8s.io/kubernetes

# Rollback to the latest bug-free version
RUN git reset --hard 2fa96eca4b92ca384a2f62279c665e2fcb3083b6

# Apply the revert patch to this bug
COPY ./bug_patch.diff k8s.io/kubernetes/bug_patch.diff
RUN git apply k8s.io/kubernetes/bug_patch.diff

# Pred-build
RUN rm -rf ./vendor/k8s.io && \
    cp -r ./vendor/* /go/src/ && \
    cp -r ./staging/src/k8s.io /go/src/

# Build
RUN cd ../apiserver/pkg/storage/cacher && \
    go test . -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/k8s.io/kubernetes/../apiserver/pkg/storage/cacher
