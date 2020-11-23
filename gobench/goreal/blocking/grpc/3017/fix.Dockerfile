FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/grpc/grpc-go.git /go/src/google.golang.org/grpc

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies
RUN go get -d -v github.com/golang/glog && \
	go get -d -v github.com/golang/protobuf/proto && \
	go get -d -v github.com/golang/protobuf/ptypes && \
	go get -d -v golang.org/x/net/context && \
	go get -d -v golang.org/x/net/http2 && \
	go get -d -v golang.org/x/net/http2/hpack && \
	go get -d -v golang.org/x/net/trace && \
	go get -d -v google.golang.org/genproto/googleapis/rpc/status

# Checkout the fixed version of this bug
WORKDIR /go/src/google.golang.org/grpc
RUN git reset --hard ac35b67779b9802189d5c0bcfc25d84ce7ba36a1




RUN go test ./balancer/grpclb -c -o /go/gobench.test