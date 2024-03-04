FROM --platform=$TARGETPLATFORM alpine:latest  AS base

RUN apk add --no-cache bash curl openssl

WORKDIR /bin

RUN curl --output self-signed-ssl https://raw.githubusercontent.com/lstellway/self-signed-ssl/master/self-signed-ssl \
    && chmod +x self-signed-ssl

```shell
docker run --rm -v ./redis.conf:/etc/redis.conf redis redis-server C:/redis/redis.windows.conf
docker run --rm -v ./redis.conf:/etc/redis.conf redis redis-server /etc/redis.conf



```
```powershell
docker run --rm `
-v c:\Users\win2022\Desktop\test:c:\redis\redis-conf `
redis redis-server C:\redis\redis-conf\redis.conf

```