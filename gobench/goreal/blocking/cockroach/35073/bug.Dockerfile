FROM golang:1.11
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Update development envirnoment
RUN apt update && apt install -y cmake autoconf bison



WORKDIR /go/src/github.com/cockroachdb/cockroach

# Download git submodules
RUN git clone https://github.com/cockroachdb/vendored vendor && \
    git clone https://github.com/cockroachdb/jemalloc.git c-deps/jemalloc && \
    git clone https://github.com/cockroachdb/rocksdb.git c-deps/rocksdb && \
    git clone https://github.com/cockroachdb/snappy.git c-deps/snappy && \
    git clone https://github.com/cockroachdb/protobuf.git c-deps/protobuf && \
    git clone https://github.com/cockroachdb/cryptopp.git c-deps/cryptopp && \
    git clone https://github.com/cockroachdb/googletest c-deps/googletest && \
    git clone https://github.com/cockroachdb/yarn-vendored pkg/ui/yarn-vendor
# Rollback to the latest bug-free version
RUN git reset --hard 6789ac585085b3c8546b77bc9c698be7f38277fb

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/cockroachdb/cockroach/bug_patch.diff
RUN git apply github.com/cockroachdb/cockroach/bug_patch.diff

# Pred-build
RUN sed -i '859s/{{.Dir}}\/{{.Name}}/\/go\/gobench/' Makefile

# Build
RUN make testbuild PKG=./pkg/sql/distsqlrun

# For entrypoint
WORKDIR /go/src/github.com/cockroachdb/cockroach/./pkg/sql/distsqlrun
