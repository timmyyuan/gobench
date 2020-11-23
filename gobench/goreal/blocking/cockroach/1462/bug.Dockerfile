FROM golang:1.8.6
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach




WORKDIR /go/src/github.com/cockroachdb/cockroach

# Rollback to the latest bug-free version
RUN git reset --hard 2f95a7668a95fcb36c05ac73e283e35205fb5298

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/cockroachdb/cockroach/bug_patch.diff
RUN git apply github.com/cockroachdb/cockroach/bug_patch.diff

# Pred-build
RUN sed -i '111s/p /p -o \/go\/gobench.test /' Makefile && \
    sed -i 's/bitbucket\.org\/tebeka\/go2xunit/github\.com\/tebeka\/go2xunit/' GLOCKFILE && \
    sed -i 's/77968f802fb3/c56ca70664d63e071d3abf0fbf70912fdf05b4ac/' GLOCKFILE && \
    sed -i '/^build: LDFLAGS*/d' Makefile

# Build
RUN make testbuild PKG=./multiraft

# For entrypoint
WORKDIR /go/src/github.com/cockroachdb/cockroach/./multiraft
