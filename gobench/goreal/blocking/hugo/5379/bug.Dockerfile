FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/gohugoio/hugo.git /go/src/github.com/gohugoio/hugo




WORKDIR /go/src/github.com/gohugoio/hugo

# Rollback to the latest bug-free version
RUN git reset --hard 729593c842794eaf7127050953a5c2256d332051

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/gohugoio/hugo/bug_patch.diff
RUN git apply github.com/gohugoio/hugo/bug_patch.diff


# Build
RUN go test ./hugolib -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/gohugoio/hugo/./hugolib
