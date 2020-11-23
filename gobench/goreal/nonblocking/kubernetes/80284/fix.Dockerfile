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
RUN git reset --hard 48ddf3be87789c92e6824c9ce536c76d008f5c19



RUN cp -rL ./vendor/* /go/src/ && \
	cd ../client-go && go test ./plugin/pkg/client/auth/exec -race -c -o /go/gobench.test