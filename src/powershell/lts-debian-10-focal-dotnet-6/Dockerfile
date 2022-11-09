FROM --platform=$TARGETPLATFORM staneee/powershell:lts-debian-10-focal


# change source
# RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
#   && sed -i "s@http://deb.debian.org@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
#   && sed -i "s@http://deb.debian.org@http://repo.huaweicloud.com@g" /etc/apt/sources.list

# install dotnet
RUN apt-get update \
    && apt-get install -y curl \
    && curl -L "https://dot.net/v1/dotnet-install.sh" -o /dotnet-install.sh \
    && chmod +x /dotnet-install.sh \
    && apt-get clean \
    && /dotnet-install.sh -c 6.0 --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet


ENTRYPOINT /bin/bash
