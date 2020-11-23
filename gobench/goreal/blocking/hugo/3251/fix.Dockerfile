FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/gohugoio/hugo.git /go/src/github.com/spf13/hugo

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/spf13/hugo
RUN git reset --hard 79b34c2f1e0ba91ff5f4f879dc42eddfd82cc563



RUN make hugo && \
	go test ./tpl/tplimpl -c -o /go/gobench.test