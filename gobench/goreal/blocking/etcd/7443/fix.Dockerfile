FROM golang:1.10
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/coreos/etcd
RUN git reset --hard 0a692b0524625996e48f5d3a47cfeac7fe9cc759




RUN sed -i '72 igo test ./clientv3 -c -o /go/gobench.test' test && \
	sed -i '73 iexit 0' test && \
	PKG=./clientv3 PASSES='build unit' ./test