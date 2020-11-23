FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/istio/istio.git /go/src/istio.io/istio

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/istio.io/istio
RUN git reset --hard be6aaeb4ede98b198c2c818b38bd3a5a0018304d




RUN go test ./mixer/adapter/list -race -c -o /go/gobench.test