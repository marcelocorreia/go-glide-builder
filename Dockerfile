FROM debian:jessie-slim
MAINTAINER Marcelo Correia <marcelo.correia@starvisitor.com>

RUN apt-get update -y
RUN apt-get install curl git wget make -y
WORKDIR /usr/local/
RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
RUN tar -xvzf go1.8.linux-amd64.tar.gz
RUN wget https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz
RUN tar -xvzf glide-v0.12.3-linux-amd64.tar.gz
RUN mv linux-amd64/glide ./bin/
RUN rm -rf go1.8.linux-amd64.tar.gz glide-v0.12.3-linux-amd64.tar.gz linux-amd64
RUN ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

ENV GOPATH=/go
ENV PATH="${PATH}:/usr/local/go/bin"
WORKDIR /




