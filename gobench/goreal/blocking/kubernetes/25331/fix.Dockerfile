FROM golang:1.10
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Install package dependencies
RUN apt-get update && \
	apt-get install -y rsync vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/k8s.io/kubernetes
RUN git reset --hard 8a81000b71ddb319ee47185194dccb196dec64bf



RUN sed -i '54s/%v\")/%v\", ep)/' ./pkg/storage/etcd3/compact.go && \
	go test ./pkg/storage/etcd3 -c -o /go/gobench.test