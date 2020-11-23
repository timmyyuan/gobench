FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/moby/moby.git /go/src/github.com/moby/moby

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/moby/moby
RUN git reset --hard ba9fb732801cfdcd55dd2a4cfce5ef5e0962fc59




RUN sed -i 's/crosbymichael/salewski/' Dockerfile && \
	sed -i '98,108d' Dockerfile