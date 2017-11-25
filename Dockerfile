FROM golang:1.9.2-alpine3.6
MAINTAINER Marcelo Correia <marcelo.correia@starvisitor.com>

RUN apk update
RUN apk add ca-certificates
RUN update-ca-certificates
RUN apk add openssl git
RUN apk add make bash curl
RUN curl https://glide.sh/get | sh

ENV PATH="${PATH}:/usr/local/go/bin"

WORKDIR /




