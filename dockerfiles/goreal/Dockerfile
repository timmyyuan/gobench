FROM golang:1.14

RUN apt update && apt install -y vim rsync python3 python3-pip python3-matplotlib

RUN pip3 install pandas numpy

RUN go get golang.org/x/tools/cmd/goimports && \
    go get github.com/sasha-s/go-deadlock && \
    go get go.uber.org/goleak


ENV PATH=/go/bin:${PATH}

WORKDIR /root/gobench