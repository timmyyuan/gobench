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
RUN git reset --hard 64346ff289aa6a817ed802a350e2633b5e2c9f9c



RUN go test ./pkg/network/status -race -c -o /go/gobench.test