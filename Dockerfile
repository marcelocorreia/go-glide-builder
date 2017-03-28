FROM debian:jessie-slim
MAINTAINER Marcelo Correia <marcelo.correia@starvisitor.com>

RUN apt-get update -y
RUN apt-get install curl git -y
WORKDIR /usr/local/
RUN curl https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz -o go1.8.linux-amd64.tar.gz
RUN tar -xvzf go1.8.linux-amd64.tar.gz
RUN apt-get install -y wget
RUN wget https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz
RUN tar -xvzf glide-v0.12.3-linux-amd64.tar.gz
RUN mv linux-amd64/glide ./bin/
RUN rm -rf go1.8.linux-amd64.tar.gz glide-v0.12.3-linux-amd64.tar.gz linux-amd64

ENV GOPATH=/go
ENV PATH="${PATH}:/usr/local/go/bin"





