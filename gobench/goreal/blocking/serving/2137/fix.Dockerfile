FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/knative/serving.git /go/src/github.com/knative/serving

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/knative/serving
RUN git reset --hard 556be431796e17044350fb47767e23ba9e2b1566




RUN go test ./pkg/queue -c -o /go/gobench.test