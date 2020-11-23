FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Install package dependencies
RUN apt-get update && \
	apt-get install -y cmake autoconf vim python3

# Clone git porject dependencies
RUN git clone https://github.com/cockroachdb/vendored /go/src/github.com/cockroachdb/cockroach/vendor && \
	git clone https://github.com/cockroachdb/jemalloc.git /go/src/github.com/cockroachdb/cockroach/c-deps/jemalloc && \
	git clone https://github.com/cockroachdb/rocksdb.git /go/src/github.com/cockroachdb/cockroach/c-deps/rocksdb && \
	git clone https://github.com/cockroachdb/snappy.git /go/src/github.com/cockroachdb/cockroach/c-deps/snappy && \
	git clone https://github.com/cockroachdb/protobuf.git /go/src/github.com/cockroachdb/cockroach/c-deps/protobuf && \
	git clone https://github.com/cockroachdb/cryptopp.git /go/src/github.com/cockroachdb/cockroach/c-deps/cryptopp && \
	git clone https://github.com/cockroachdb/googletest /go/src/github.com/cockroachdb/cockroach/c-deps/googletest && \
	git clone https://github.com/cockroachdb/yarn-vendored /go/src/github.com/cockroachdb/cockroach/pkg/ui/yarn-vendor

# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN git reset --hard 7055cc8d96883bda2f69bb1fe8bc7512b2543132




RUN sed -i '616s/$/& -Wno-error=class-memaccess/g' Makefile && \
	sed -i '802s/{{.Dir}}\/{{.Name}}/\/go\/gobench/' Makefile && \
	make testbuild PKG=./pkg/storage