FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/moby/moby.git /go/src/github.com/moby/moby




WORKDIR /go/src/github.com/moby/moby

# Rollback to the latest bug-free version
RUN git reset --hard f10a222de1cc756bb14d157b778d820fac3561aa

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/moby/moby/bug_patch.diff
RUN git apply github.com/moby/moby/bug_patch.diff

# Pred-build
RUN sed -i '47s/--rm//' Makefile && \
    sed -i '47s/MOUNT)/MOUNT) -v \/go\/test:\/go\/test --name moby_22941_cntr/' Makefile && \
    sed -i '31 iRUN apt-get update \&\& apt-get install -y apt-transport-https ca-certificates' Dockerfile && \
    sed -i '26s/\$COVER //' hack/make/test-unit && \
    sed -i '26s/go test.*/&\n\t&/' hack/make/test-unit && \
    sed -i '26s/$/ -i/' hack/make/test-unit && \
    sed -i '27s/\$pkg_list//' hack/make/test-unit && \
    sed -i '27s/$/ -c -o \/go\/gobench.test/' hack/make/test-unit


# For entrypoint
WORKDIR /go/src/github.com/moby/moby/.
