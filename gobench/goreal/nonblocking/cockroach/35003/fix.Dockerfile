FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Install package dependencies
RUN apt-get update && \
	apt-get install -y cmake autoconf bison vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN git reset --hard 563dbae003ea79b017842b24bc9d81b574e0a367




RUN sed -i '865 i\	\$(xgo) test \$(GOFLAGS) -exec \x27stress \$(STRESSFLAGS)\x27 -tags \x27\$(TAGS)\x27 -ldflags \x27\$(LINKFLAGS)\x27 \$(PKG) -c -o /go/gobench.test' Makefile && \
	sed -i '866d' Makefile && \
	make stressrace PKG=./pkg/sql/logictest TESTTIMEOUT=5m STRESSFLAGS='-maxtime 20m -timeout 10m'