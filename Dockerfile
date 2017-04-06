FROM debian:jessie-slim
MAINTAINER Marcelo Correia <marcelo.correia@starvisitor.com>

RUN apt-get update -y
RUN apt-get install -y apt-utils curl git wget make python-pip  apt-transport-https ca-certificates  python-software-properties
RUN pip install --upgrade bumpversion

RUN ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
CMD echo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jessie stable"
RUN  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

RUN apt-get update
RUN apt-get install -y docker-ce
RUN usermod -a -G docker ubuntu

WORKDIR /usr/local/
RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
RUN tar -xvzf go1.8.linux-amd64.tar.gz
RUN wget https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz
RUN tar -xvzf glide-v0.12.3-linux-amd64.tar.gz
RUN mv linux-amd64/glide ./bin/
RUN rm -rf go1.8.linux-amd64.tar.gz glide-v0.12.3-linux-amd64.tar.gz linux-amd64

ENV GOPATH=/go
ENV PATH="${PATH}:/usr/local/go/bin"

WORKDIR /




