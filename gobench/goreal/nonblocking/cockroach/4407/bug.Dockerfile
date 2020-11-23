FROM golang:1.5
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach




WORKDIR /go/src/github.com/cockroachdb/cockroach

# Rollback to the latest bug-free version
RUN git reset --hard 7174fe531297b2e2ff5f3b811c3646d6819bc990

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/cockroachdb/cockroach/bug_patch.diff
RUN git apply github.com/cockroachdb/cockroach/bug_patch.diff

# Pred-build
RUN sed -i '87s/"\$\$DIR"\/"\$\$OUT"/\/go\/gobench.test/' Makefile

# Build
RUN make testbuild TESTFLAGS=-race PKG=./gossip

# For entrypoint
WORKDIR /go/src/github.com/cockroachdb/cockroach/./gossip
