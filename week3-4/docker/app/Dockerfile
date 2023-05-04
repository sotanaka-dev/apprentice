FROM ubuntu:latest

RUN yes | unminimize \
  && apt-get update \
  && apt-get install -y \
  man \
  less \
  tree \
  vim \
  gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV TERM xterm-256color
COPY config/.vimrc /root/
COPY config/molokai.vim /root/.vim/colors/

WORKDIR /app
