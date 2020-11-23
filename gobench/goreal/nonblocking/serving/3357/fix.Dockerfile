FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/github.com/knative/serving

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/knative/serving
RUN git reset --hard 8c2d150c3177fc307d9770433b2ffc08b5b9f84f




RUN go test ./pkg/reconciler/v1alpha1/route -race -c -o /go/gobench.test