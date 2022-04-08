FROM mcr.microsoft.com/powershell:lts-debian-10

# change source
# RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
#     && sed -i "s@http://ftp.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list \
#     && sed -i "s@http://security.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list

# nodejs install
RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get clean

ENTRYPOINT /bin/bash
