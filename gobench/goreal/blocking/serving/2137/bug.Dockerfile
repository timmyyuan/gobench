FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/github.com/knative/serving




WORKDIR /go/src/github.com/knative/serving

# Rollback to the latest bug-free version
RUN git reset --hard 556be431796e17044350fb47767e23ba9e2b1566

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/knative/serving/bug_patch.diff
RUN git apply github.com/knative/serving/bug_patch.diff


# Build
RUN go test ./pkg/queue -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/knative/serving//go/src/github.com/knative/serving/pkg/queue
