FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/knative.dev/serving

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/knative.dev/serving
RUN git reset --hard 1d7e60cb3508d62347e2cbafd9fde072f3908ad5



RUN go test ./pkg/activator/handler -race -c -o /go/gobench.test