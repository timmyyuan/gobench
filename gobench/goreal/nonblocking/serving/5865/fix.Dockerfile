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
RUN git reset --hard 995194b9504551469776da3bf71f45371b3948f8



RUN go test ./pkg/activator/net -race -c -o /go/gobench.test