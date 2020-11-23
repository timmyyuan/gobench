FROM golang:1.6
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Install package dependencies
RUN apt-get update && \
	apt-get install -y vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN git reset --hard 83b4b42082555f829a13c4f523b118ed406c4190




RUN sed -i 's/bitbucket\.org\/tebeka\/go2xunit/github\.com\/tebeka\/go2xunit/' GLOCKFILE && \
	sed -i 's/77968f802fb3/c56ca70664d63e071d3abf0fbf70912fdf05b4ac/' GLOCKFILE && \
	sed -i '75s/PKG)/PKG) -c -o \/go\/gobench.test/' Makefile && \
	sed -i '76d' Makefile && \
	make test PKG=./util