FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio




WORKDIR /go/src/istio.io/istio

# Rollback to the latest bug-free version
RUN git reset --hard c6e9130227497ab064dd571a1409236d17aa2ef3

# Apply the revert patch to this bug
COPY ./bug_patch.diff istio.io/istio/bug_patch.diff
RUN git apply istio.io/istio/bug_patch.diff

# Pred-build
RUN echo 'replace bitbucket.org/ww/goautoneg => github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822' >> go.mod

# Build
RUN go test ./pkg/envoy -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/istio.io/istio/./pkg/envoy
