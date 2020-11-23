FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/gohugoio/hugo.git /go/src/github.com/spf13/hugo




WORKDIR /go/src/github.com/spf13/hugo

# Rollback to the latest bug-free version
RUN git reset --hard 79b34c2f1e0ba91ff5f4f879dc42eddfd82cc563

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/spf13/hugo/bug_patch.diff
RUN git apply github.com/spf13/hugo/bug_patch.diff

# Pred-build
RUN make hugo

# Build
RUN go test ./tpl/tplimpl -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/spf13/hugo/./tpl/tplimpl
