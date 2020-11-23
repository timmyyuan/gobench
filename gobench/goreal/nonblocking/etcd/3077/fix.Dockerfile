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
RUN git reset --hard 5be545b872a5a5938f9664668c0022ca877c5439




RUN sed -i '17s/GitSHA /GitSHA=/' build && \
	sed -i '47 igo test ./etcdserver -race -c -o \/go\/gobench.test' test && \
	sed -i '48 iexit 0' test && \
	./test