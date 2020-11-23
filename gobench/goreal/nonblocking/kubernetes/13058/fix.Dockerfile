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
RUN git reset --hard d15de72a92c8841d069b1265e433eb52edc29822



RUN sed -i '231,247d' hack/lib/golang.sh && \
	sed -i '204 igo test ./pkg/controller/framework -race -c -o /go/gobench.test' hack/test-go.sh && \
	sed -i '205 iexit 0' hack/test-go.sh && \
	make test WHAT=./pkg/controller/framework