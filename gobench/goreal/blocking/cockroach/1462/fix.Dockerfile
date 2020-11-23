FROM golang:1.8.6
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN git reset --hard 2f95a7668a95fcb36c05ac73e283e35205fb5298




RUN sed -i '111s/p /p -o \/go\/gobench.test /' Makefile && \
	sed -i 's/bitbucket\.org\/tebeka\/go2xunit/github\.com\/tebeka\/go2xunit/' GLOCKFILE && \
	sed -i 's/77968f802fb3/c56ca70664d63e071d3abf0fbf70912fdf05b4ac/' GLOCKFILE && \
	sed -i '/^build: LDFLAGS*/d' Makefile && \
	make testbuild PKG=./multiraft