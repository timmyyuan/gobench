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
RUN git reset --hard 95f4d27b65d5ab09c81066045034e9286e278430




RUN sed -i '478s/%d/%v/' ./test/end2end_test.go && \
	sed -i '1866s/Canceled\")/Canceled\", got)/' ./test/end2end_test.go && \
	sed -i '1848s/Canceled\")/Canceled\", got)/' ./test/end2end_test.go && \
	sed -i '1882s/RunTests//' ./test/end2end_test.go && \
	sed -i '1864s/RunTests//' ./test/end2end_test.go && \
	go test ./test -c -o /go/gobench.test