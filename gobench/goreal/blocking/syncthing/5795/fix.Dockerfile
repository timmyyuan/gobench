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
RUN git reset --hard 02752af86233849746c638f3e8cbbd78cce46878



RUN go test ./lib/protocol -c -o /go/gobench.test