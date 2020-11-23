FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/k8s.io/kubernetes
RUN git reset --hard f5e6161e499b913f869204085d89f6a131f500bd



RUN sed -i '158 igo test ./contrib/mesos/pkg/election -c -o /go/gobench.test' hack/test-go.sh && \
	sed -i '159 iexit 0' hack/test-go.sh && \
	sed -i '232,241d' hack/lib/golang.sh && \
	make test WHAT=./contrib/mesos/pkg/election