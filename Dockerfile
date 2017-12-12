FROM golang:1.9.2-alpine3.6
MAINTAINER marcelo correia <marcelo@correia.io>
RUN apk update
RUN apk add ca-certificates
RUN update-ca-certificates
RUN apk add --no-cache\
    openssl \
    git \
    make \
    bash \
    curl \
    tar \
    perl \
    zip
RUN curl https://glide.sh/get | sh
RUN mkdir /tmp/gox
RUN GOPATH=$(pwd) go get -u github.com/mitchellh/gox
RUN mv bin/gox /usr/local/bin
WORKDIR /tmp/gox
ENV PATH="${PATH}:/usr/local/go/bin"
WORKDIR /




