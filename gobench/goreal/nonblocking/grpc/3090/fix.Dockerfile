FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/grpc/grpc-go.git /go/src/google.golang.org/grpc

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/google.golang.org/grpc
RUN git reset --hard 027cd627f8565bf731a6e1bdf54ce79ba09bda5c




RUN sed -i 's/func (s) TestResolverErrorInBuild/func TestResolverErrorInBuild/' ./resolver_conn_wrapper_test.go && \
	go test . -race -c -o /go/gobench.test