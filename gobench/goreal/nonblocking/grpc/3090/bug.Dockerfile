FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/grpc/grpc-go.git /go/src/google.golang.org/grpc




WORKDIR /go/src/google.golang.org/grpc

# Rollback to the latest bug-free version
RUN git reset --hard 027cd627f8565bf731a6e1bdf54ce79ba09bda5c

# Apply the revert patch to this bug
COPY ./bug_patch.diff google.golang.org/grpc/bug_patch.diff
RUN git apply google.golang.org/grpc/bug_patch.diff

# Pred-build
RUN sed -i 's/func (s) TestResolverErrorInBuild/func TestResolverErrorInBuild/' ./resolver_conn_wrapper_test.go

# Build
RUN go test . -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/google.golang.org/grpc/.
