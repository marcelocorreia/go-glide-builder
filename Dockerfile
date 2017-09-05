FROM golang:1.9.0-alpine
MAINTAINER Marcelo Correia <marcelo.correia@starvisitor.com>
ARG glide_version="v0.12.3"

RUN apk update
RUN apk add ca-certificates
RUN update-ca-certificates
RUN apk add openssl git
RUN wget https://github.com/Masterminds/glide/releases/download/${glide_version}/glide-${glide_version}-linux-amd64.tar.gz

RUN tar -xvzf glide-${glide_version}-linux-amd64.tar.gz
RUN mv linux-amd64/glide /usr/local/bin/glide
RUN apk add make bash

ENV PATH="${PATH}:/usr/local/go/bin"

WORKDIR /




