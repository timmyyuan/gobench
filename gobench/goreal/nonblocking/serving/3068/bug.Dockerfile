FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/github.com/knative/serving




WORKDIR /go/src/github.com/knative/serving

# Rollback to the latest bug-free version
RUN git reset --hard b5e383b3318333cb0d38258be34fc402c33989c7

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/knative/serving/bug_patch.diff
RUN git apply github.com/knative/serving/bug_patch.diff


# Build
RUN go test ./pkg/pool -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/knative/serving/./pkg/pool
