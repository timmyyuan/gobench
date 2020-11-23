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
RUN git reset --hard 7c1c96551d41e369a588e365a9bb99acb5bc8fdb




RUN sed -i '50s/--rm//' Makefile && \
	sed -i '50s/MOUNT)/MOUNT) -v \/go\/test:\/go\/test --name moby_18412_cntr/' Makefile && \
	sed -i 's/git.fedorahosted.org\/git/github.com\/lvmteam/' Dockerfile && \
	sed -i '31 iRUN apt-get update \&\& apt-get install -y apt-transport-https ca-certificates' Dockerfile && \
	sed -i '119,127d' Dockerfile && \
	sed -i '25s/\$COVER //' hack/make/test-unit && \
	sed -i '25s/go test.*/&\n\t&/' hack/make/test-unit && \
	sed -i '25s/$/ -i/' hack/make/test-unit && \
	sed -i '26s/\$pkg_list//' hack/make/test-unit && \
	sed -i '26s/$/ -c -o \/go\/gobench.test/' hack/make/test-unit