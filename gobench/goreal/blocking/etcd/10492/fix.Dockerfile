FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/coreos/etcd
RUN git reset --hard 4b69cfc56b070456cefabea86e57f9ccd1ab09a2




RUN sed -i '135 igo test ./lease -c -o /go/gobench.test' test && \
	sed -i '136 iexit 0' test && \
	VERBOSE=1 PKG=./lease PASSES='unit' ./test