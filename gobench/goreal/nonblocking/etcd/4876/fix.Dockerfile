FROM golang:1.6
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/coreos/etcd
RUN git reset --hard d533c14881d7b69d64047645816d56a61269b844




RUN sed -i '130d' test && \
	sed -i '127d' test && \
	sed -i '63 igo test \${REPO_PATH}/clientv3/integration -race -c -o /go/gobench.test' test && \
	sed -i '64 iexit 0' test && \
	sed -i '61,62d' test && \
	INTEGRATION=1 ./test