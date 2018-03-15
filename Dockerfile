FROM debian:stable-slim
MAINTAINER marcelo correia <marcelo@correia.io>
RUN apt-get update
RUN apt-get install -y \
    openssl \
    git \
    make \
    bash \
    curl \
    tar \
    perl \
    zip \
    vim \
    jq


WORKDIR /usr/local
RUN curl https://dl.google.com/go/go1.10.linux-amd64.tar.gz \
    -o /usr/local/go1.10.linux-amd64.tar.gz
RUN tar -xvzf go1.10.linux-amd64.tar.gz
RUN apt-get install vim -y
RUN echo export 'PATH="$PATH:/usr/local/go/bin"' >> $HOME/.bashrc
ENV PATH=$PATH:/usr/local/go/bin
RUN curl https://github.com/Masterminds/glide/releases/download/v0.13.1/glide-v0.13.1-linux-amd64.tar.gz \
    -o /usr/local/bin/glide-v0.13.1-linux-amd64.tar.gz -L

WORKDIR /usr/local/bin
RUN tar -xvzf glide-v0.13.1-linux-amd64.tar.gz
RUN mv /usr/local/bin/linux-amd64/glide /usr/local/bin/glide
RUN mkdir /tmp/gox

WORKDIR /tmp/gox
RUN GOPATH=$(pwd) go get -u github.com/mitchellh/gox
RUN mv bin/gox /usr/local/bin
ENV PATH="${PATH}:/usr/local/go/bin"

RUN rm -rf \
    /usr/local/bin/glide-v0.13.1-linux-amd64.tar.gz \
    /usr/local/bin/linux-amd64/ \
    /usr/local/go1.10.linux-amd64.tar.gz \
    /tmp/gox

WORKDIR /




