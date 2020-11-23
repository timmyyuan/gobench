FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/knative.dev/serving




WORKDIR /go/src/knative.dev/serving

# Rollback to the latest bug-free version
RUN git reset --hard 043aa03e459ce238b5681abf8fb480f4f9d4668e

# Apply the revert patch to this bug
COPY ./bug_patch.diff knative.dev/serving/bug_patch.diff
RUN git apply knative.dev/serving/bug_patch.diff


# Build
RUN go test ./pkg/activator -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/knative.dev/serving/./pkg/activator
