FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/moby/moby.git /go/src/github.com/moby/moby




WORKDIR /go/src/github.com/moby/moby

# Rollback to the latest bug-free version
RUN git reset --hard ba9fb732801cfdcd55dd2a4cfce5ef5e0962fc59

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/moby/moby/bug_patch.diff
RUN git apply github.com/moby/moby/bug_patch.diff

# Pred-build
RUN sed -i 's/crosbymichael/salewski/' Dockerfile && \
    sed -i '98,108d' Dockerfile


# For entrypoint
WORKDIR /go/src/github.com/moby/moby/.
