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
RUN git reset --hard 628af356b8c83f98ee3b50dfcf8b0250816a5581



RUN go test ./pkg/controller/framework -c -o /go/gobench.test