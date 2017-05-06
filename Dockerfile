FROM golang:1.8.1-alpine
MAINTAINER Marcelo Correia <marcelo.correia@starvisitor.com>
#
#RUN apt-get update -y
#RUN apt-get install -y apt-utils curl git wget make  apt-transport-https ca-certificates  python-software-properties
#
#WORKDIR /usr/local/
#RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
#RUN tar -xvzf go1.8.linux-amd64.tar.gz
#WORKDIR /usr/local/bin
RUN apk update
RUN apk add ca-certificates
RUN update-ca-certificates
RUN apk add openssl git
RUN wget https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz

RUN tar -xvzf glide-v0.12.3-linux-amd64.tar.gz
RUN mv linux-amd64/glide /usr/local/bin/glide
RUN apk add make bash

ENV PATH="${PATH}:/usr/local/go/bin"

WORKDIR /




