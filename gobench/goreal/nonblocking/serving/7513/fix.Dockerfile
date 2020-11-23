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
RUN git reset --hard 4596520451dc0169d334ea5e62346b8e968374a2



RUN go test ./pkg/reconciler/route -race -c -o /go/gobench.test