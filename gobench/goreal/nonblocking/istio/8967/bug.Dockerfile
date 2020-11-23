FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio




WORKDIR /go/src/istio.io/istio

# Rollback to the latest bug-free version
RUN git reset --hard 60c1297527cad3f33e2fe0afbb201c551588862e

# Apply the revert patch to this bug
COPY ./bug_patch.diff istio.io/istio/bug_patch.diff
RUN git apply istio.io/istio/bug_patch.diff


# Build
RUN go test ./galley/pkg/fs -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/istio.io/istio/./galley/pkg/fs
