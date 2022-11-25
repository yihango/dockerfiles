FROM --platform=$TARGETPLATFORM staneee/powershell:lts-debian-10-focal-docker-20-10-21


# change source
# RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
#   && sed -i "s@http://deb.debian.org@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
#   && sed -i "s@http://deb.debian.org@http://repo.huaweicloud.com@g" /etc/apt/sources.list

# install zip
RUN apt-get update \
  && apt-get install -y zip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* 


ENTRYPOINT /bin/bash
