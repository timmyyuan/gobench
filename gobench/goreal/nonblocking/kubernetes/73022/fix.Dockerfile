FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes

# Install package dependencies
RUN apt-get update && \
	apt-get install -y rsync vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/k8s.io/kubernetes
RUN git reset --hard c999dc3854d7b14aa28b7c61622a8bc2975e5367



RUN sed -i '286 igo test ./pkg/scheduler/internal/queue -race -c -o /go/gobench.test' hack/make-rules/test.sh && \
	sed -i '287 iexit 0' hack/make-rules/test.sh && \
	make test WHAT=./pkg/scheduler/internal/queue