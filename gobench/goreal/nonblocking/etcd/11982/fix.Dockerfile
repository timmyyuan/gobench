FROM golang:1.14
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/go.etcd.io/etcd

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/go.etcd.io/etcd
RUN git reset --hard 3082a7d52119960a2bdc0c60566186c54df9bc35



RUN sed -i '159 igo test \${REPO_PATH}/integration -race -c -o /go/gobench.test' test && \
	sed -i '160 iexit 0' test && \
	VERBOSE=1 PKG=integration PASSES=integration TESTCASE=TestIssue2746WithThree ./test