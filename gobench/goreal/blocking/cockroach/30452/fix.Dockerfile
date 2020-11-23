FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Install package dependencies
RUN apt-get update && \
	apt-get install -y cmake autoconf bison libncurses5-dev vim python3

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
RUN git reset --hard db68ad943b2677a18ad8ab3ed8dc20d8c2790f7e




RUN sed -i '836s/-run.*//' Makefile && \
	sed -i '836s/$/ \$(PKG) -c -o \/go\/gobench.test/' Makefile && \
	make stress PKG=./pkg/storage/ STRESSFLAGS='-maxtime 20m -timeout 10m'