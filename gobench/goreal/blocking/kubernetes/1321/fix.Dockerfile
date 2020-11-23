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
RUN git reset --hard 9c25792dca98c8ae798a2c0763c1a08934fe567c



RUN sed -i '147 igo test "\${pkg}" -c -o /go/gobench.test' hack/test-go.sh && \
	sed -i '148 iexit 0' hack/test-go.sh && \
	sed -i '130,135d' hack/config-go.sh && \
	make test WHAT=./pkg/watch