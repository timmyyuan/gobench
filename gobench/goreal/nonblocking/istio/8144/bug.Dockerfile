FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio




WORKDIR /go/src/istio.io/istio

# Rollback to the latest bug-free version
RUN git reset --hard 39f7d47451787313c06fafca6918c0b9eda8896d

# Apply the revert patch to this bug
COPY ./bug_patch.diff istio.io/istio/bug_patch.diff
RUN git apply istio.io/istio/bug_patch.diff


# Build
RUN go test ./mixer/adapter/prometheus -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/istio.io/istio/./mixer/adapter/prometheus
