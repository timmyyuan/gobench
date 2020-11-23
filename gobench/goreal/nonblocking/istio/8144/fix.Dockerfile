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
RUN git reset --hard 39f7d47451787313c06fafca6918c0b9eda8896d




RUN go test ./mixer/adapter/prometheus -race -c -o /go/gobench.test