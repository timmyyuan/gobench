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
RUN git reset --hard 4728b94bc9f00b0d3109df142d5b37a314bf08b3




RUN go test ./pilot/pkg/config/memory -c -o /go/gobench.test