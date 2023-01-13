FROM --platform=$TARGETPLATFORM alpine:latest  AS base

RUN apk add --no-cache bash curl openssl

WORKDIR /bin

RUN curl --output self-signed-ssl https://raw.githubusercontent.com/lstellway/self-signed-ssl/master/self-signed-ssl \
    && chmod +x self-signed-ssl

