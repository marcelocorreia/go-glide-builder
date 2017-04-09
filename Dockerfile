FROM debian:jessie-slim
MAINTAINER Marcelo Correia <marcelo.correia@starvisitor.com>

RUN apt-get update -y
RUN apt-get install -y apt-utils curl git wget make  apt-transport-https ca-certificates  python-software-properties

WORKDIR /usr/local/
RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
RUN tar -xvzf go1.8.linux-amd64.tar.gz
WORKDIR /usr/local/bin
RUN wget https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz
RUN tar -xvzf glide-v0.12.3-linux-amd64.tar.gz
RUN mv linux-amd64/glide .
RUN rm -rf go1.8.linux-amd64.tar.gz glide-v0.12.3-linux-amd64.tar.gz linux-amd64

ENV GOPATH=/go
ENV PATH="${PATH}:/usr/local/go/bin"

WORKDIR /




