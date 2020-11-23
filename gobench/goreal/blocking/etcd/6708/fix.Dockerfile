FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/etcd-io/etcd.git /go/src/github.com/coreos/etcd

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies
RUN go get -d -v github.com/ugorji/go/codec && \
	go get -d -v golang.org/x/net/context

# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/coreos/etcd
RUN git reset --hard 4f60f1b71f8608bc6f5c2a3296561cbc16d94d12




RUN cd /go/src/github.com/ugorji/go/codec && \
	git reset --hard faddd6128c66c4708f45fdc007f575f75e592a3c && \
	cd /go/src/github.com/coreos/etcd && go test ./client -c -o /go/gobench.test