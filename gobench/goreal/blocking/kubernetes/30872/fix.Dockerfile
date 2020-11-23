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
RUN git reset --hard b15c2d67e672897fc1b30dd879d8f4c6065181a5



RUN go test ./federation/pkg/federation-controller/namespace -c -o /go/gobench.test