FROM golang:1.9
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
	git clone https://github.com/cockroachdb/protobuf.git /go/src/github.com/cockroachdb/cockroach/c-deps/protobuf

# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN git reset --hard b12d4f2abbf8669ce46ed5ca54ac266bfb4b2eb2




RUN sed -i '194s/{{.Dir}}\/{{.Name}}/\/go\/gobench/' Makefile && \
	make testbuild PKG=./pkg/storage