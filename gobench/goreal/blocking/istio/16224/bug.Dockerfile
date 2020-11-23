FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio




WORKDIR /go/src/istio.io/istio

# Rollback to the latest bug-free version
RUN git reset --hard 4728b94bc9f00b0d3109df142d5b37a314bf08b3

# Apply the revert patch to this bug
COPY ./bug_patch.diff istio.io/istio/bug_patch.diff
RUN git apply istio.io/istio/bug_patch.diff


# Build
RUN go test ./pilot/pkg/config/memory -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/istio.io/istio/./pilot/pkg/config/memory
