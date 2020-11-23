FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Update development envirnoment
RUN apt update && apt install -y cmake autoconf bison



WORKDIR /go/src/github.com/cockroachdb/cockroach

# Rollback to the latest bug-free version
RUN git reset --hard 563dbae003ea79b017842b24bc9d81b574e0a367

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/cockroachdb/cockroach/bug_patch.diff
RUN git apply github.com/cockroachdb/cockroach/bug_patch.diff

# Pred-build
RUN sed -i '865 i\	\$(xgo) test \$(GOFLAGS) -exec \x27stress \$(STRESSFLAGS)\x27 -tags \x27\$(TAGS)\x27 -ldflags \x27\$(LINKFLAGS)\x27 \$(PKG) -c -o /go/gobench.test' Makefile && \
    sed -i '866d' Makefile

# Build
RUN make stressrace PKG=./pkg/sql/logictest TESTTIMEOUT=5m STRESSFLAGS='-maxtime 2m -timeout 1m'

# For entrypoint
WORKDIR /go/src/github.com/cockroachdb/cockroach/./pkg/sql/logictest
