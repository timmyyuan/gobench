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
RUN git reset --hard 673c6f065080be10403515826e1c7f58c20dbcd3




RUN sed -i '83 igo test ./lease -race -c -o /go/gobench.test' test && \
	sed -i '84 iexit 0' test && \
	VERBOSE=1 PKG=./lease PASSES=unit TESTCASE=TestLessorRenewExtendPileup ./test