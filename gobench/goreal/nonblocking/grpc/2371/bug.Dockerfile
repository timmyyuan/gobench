FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/grpc/grpc-go.git /go/src/google.golang.org/grpc




WORKDIR /go/src/google.golang.org/grpc

# Rollback to the latest bug-free version
RUN git reset --hard cb11627444a397d423a7e5712c97395a4186f4df

# Apply the revert patch to this bug
COPY ./bug_patch.diff google.golang.org/grpc/bug_patch.diff
RUN git apply google.golang.org/grpc/bug_patch.diff


# Build
RUN go test . -race -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/google.golang.org/grpc/.
