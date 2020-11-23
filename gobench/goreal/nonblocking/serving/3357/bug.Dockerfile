FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/github.com/knative/serving




WORKDIR /go/src/github.com/knative/serving

# Rollback to the latest bug-free version
RUN git reset --hard 8c2d150c3177fc307d9770433b2ffc08b5b9f84f

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/knative/serving/bug_patch.diff
RUN git apply github.com/knative/serving/bug_patch.diff


# Build
RUN go test ./pkg/reconciler/v1alpha1/route -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/knative/serving/./pkg/reconciler/v1alpha1/route
