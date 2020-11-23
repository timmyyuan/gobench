FROM golang:1.5
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN git reset --hard 7174fe531297b2e2ff5f3b811c3646d6819bc990




RUN sed -i '87s/"\$\$DIR"\/"\$\$OUT"/\/go\/gobench.test/' Makefile && \
	make testbuild TESTFLAGS=-race PKG=./gossip