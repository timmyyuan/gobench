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
RUN git reset --hard 25074a190ef2a07d8b0ed38734f2cb373edfb868



RUN sed -i '287 igo test ./pkg/credentialprovider/aws -race -c -o /go/gobench.test' hack/make-rules/test.sh && \
	sed -i '288 iexit 0' hack/make-rules/test.sh && \
	make test WHAT=./pkg/credentialprovider/aws