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
RUN git reset --hard 2fa96eca4b92ca384a2f62279c665e2fcb3083b6



RUN rm -rf ./vendor/k8s.io && \
	cp -r ./vendor/* /go/src/ && \
	cp -r ./staging/src/k8s.io /go/src/ && \
	cd ../apiserver/pkg/storage/cacher && \
	go test . -race -c -o /go/gobench.test