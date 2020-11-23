FROM golang:1.12
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/github.com/knative/serving

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/knative/serving
RUN git reset --hard 3f9f91e13f624e2a8b7788e821296eaa6199b38f




RUN go test ./pkg/reconciler/v1alpha1/revision -race -c -o /go/gobench.test