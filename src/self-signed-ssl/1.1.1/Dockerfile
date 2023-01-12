FROM --platform=$TARGETPLATFORM alpine:latest  AS base

WORKDIR /bin

RUN apk add --no-cache bash \
    && apk add --no-cache curl \
    && apk add --no-cache openssl \
    && curl --output self-signed-ssl https://raw.githubusercontent.com/lstellway/self-signed-ssl/master/self-signed-ssl \
    && chmod +x self-signed-ssl

