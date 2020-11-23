FROM golang:1.12
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/github.com/knative/serving




WORKDIR /go/src/github.com/knative/serving

# Rollback to the latest bug-free version
RUN git reset --hard 3f9f91e13f624e2a8b7788e821296eaa6199b38f

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/knative/serving/bug_patch.diff
RUN git apply github.com/knative/serving/bug_patch.diff


# Build
RUN go test ./pkg/reconciler/v1alpha1/revision -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/knative/serving/./pkg/reconciler/v1alpha1/revision
