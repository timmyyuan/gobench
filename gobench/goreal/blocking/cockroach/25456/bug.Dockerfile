FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Update development envirnoment
RUN apt update && apt install -y cmake autoconf



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
RUN git reset --hard 7055cc8d96883bda2f69bb1fe8bc7512b2543132

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/cockroachdb/cockroach/bug_patch.diff
RUN git apply github.com/cockroachdb/cockroach/bug_patch.diff

# Pred-build
RUN sed -i '616s/$/& -Wno-error=class-memaccess/g' Makefile && \
    sed -i '802s/{{.Dir}}\/{{.Name}}/\/go\/gobench/' Makefile

# Build
RUN make testbuild PKG=./pkg/storage

# For entrypoint
WORKDIR /go/src/github.com/cockroachdb/cockroach/./pkg/storage
