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
RUN git reset --hard 318d2ba92ce81e12e8da0d1e896d2367c5a30cd3




RUN go test ./galley/pkg/runtime -c -o /go/gobench.test