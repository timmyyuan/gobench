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
RUN git reset --hard 9ed3b446cadd9f43734d9eed9dcb03f3b12567a5




RUN sed -i '167s/fmt_tests/# fmt_tests/' test && \
	sed -i '170s/unit_tests/# unit_tests/' test && \
	sed -i '73,74d' test && \
	sed -i '72 igo test \${REPO_PATH}/clientv3/integration -c -o /go/gobench.test' test && \
	sed -i '73 iexit 0' test && \
	sed -i '66,71d' test && \
	INTEGRATION=1 ./test