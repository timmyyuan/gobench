FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio




WORKDIR /go/src/istio.io/istio

# Rollback to the latest bug-free version
RUN git reset --hard 318d2ba92ce81e12e8da0d1e896d2367c5a30cd3

# Apply the revert patch to this bug
COPY ./bug_patch.diff istio.io/istio/bug_patch.diff
RUN git apply istio.io/istio/bug_patch.diff


# Build
RUN go test ./galley/pkg/runtime -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/istio.io/istio/./galley/pkg/runtime
