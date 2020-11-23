FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/syncthing/syncthing.git /go/src/github.com/syncthing/syncthing

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/syncthing/syncthing
RUN git reset --hard e7dc2f91900c9394529190de921c96b3b2d4eb44



RUN go test ./lib/nat -c -o /go/gobench.test