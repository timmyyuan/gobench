FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/gohugoio/hugo.git /go/src/github.com/gohugoio/hugo

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/gohugoio/hugo
RUN git reset --hard 729593c842794eaf7127050953a5c2256d332051



RUN go test ./hugolib -c -o /go/gobench.test