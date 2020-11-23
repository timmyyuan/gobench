FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio




WORKDIR /go/src/istio.io/istio

# Rollback to the latest bug-free version
RUN git reset --hard be6aaeb4ede98b198c2c818b38bd3a5a0018304d

# Apply the revert patch to this bug
COPY ./bug_patch.diff istio.io/istio/bug_patch.diff
RUN git apply istio.io/istio/bug_patch.diff


# Build
RUN go test ./mixer/adapter/list -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/istio.io/istio/./mixer/adapter/list
