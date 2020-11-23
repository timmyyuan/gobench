FROM golang:1.12
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Install package dependencies
RUN apt-get update && \
	apt-get install -y rsync vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/k8s.io/kubernetes
RUN git reset --hard f02c8e47bc41e76594aec1b4db80900e9a2a9a15



RUN sed -i '169s/a)/a\.\.\.)/' pkg/storage/errors.go && \
	go test ./pkg/storage/ -c -o /go/gobench.test