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
RUN git reset --hard cda495f5093cc917d80f25686c2a16dffcbe85dd




RUN go test ./pilot/pkg/proxy/envoy/v2 -race -c -o /go/gobench.test