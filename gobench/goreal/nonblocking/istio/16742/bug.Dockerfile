FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio




WORKDIR /go/src/istio.io/istio

# Rollback to the latest bug-free version
RUN git reset --hard cda495f5093cc917d80f25686c2a16dffcbe85dd

# Apply the revert patch to this bug
COPY ./bug_patch.diff istio.io/istio/bug_patch.diff
RUN git apply istio.io/istio/bug_patch.diff


# Build
RUN go test ./pilot/pkg/proxy/envoy/v2 -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/istio.io/istio/./pilot/pkg/proxy/envoy/v2
