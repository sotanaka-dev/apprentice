FROM ruby:latest

RUN apt-get update && apt-get install -y \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
