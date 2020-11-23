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
RUN git reset --hard 576a2ca501e95f7343df19ad1aa2183058440d57




RUN sed -i '133 igo test \${REPO_PATH}/integration -race -c -o /go/gobench.test' test && \
	sed -i '134 iexit 0' test && \
	VERBOSE=1 PKG=integration PASSES=integration TESTCASE=TestV3MaintenanceDefragmentInflightRange ./test