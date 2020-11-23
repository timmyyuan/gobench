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
RUN git reset --hard 919d2c11260f762a27c8918ea8375aa4a7dc873c



RUN sed -i '235,251d' hack/lib/golang.sh && \
	sed -i '232 igo test ./contrib/mesos/pkg/scheduler -c -o /go/gobench.test' hack/test-go.sh && \
	sed -i '233 iexit 0' hack/test-go.sh && \
	sed -i '809d' contrib/mesos/pkg/scheduler/plugin.go && \
	sed -i '464d' contrib/mesos/pkg/scheduler/scheduler.go && \
	make test WHAT=./contrib/mesos/pkg/scheduler