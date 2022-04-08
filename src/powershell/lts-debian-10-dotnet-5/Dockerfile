FROM mcr.microsoft.com/powershell:lts-debian-10

# change source
# RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
#     && sed -i "s@http://ftp.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list \
#     && sed -i "s@http://security.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list

# dotnet install
RUN apt-get update \
    && apt-get install -y curl \
    && curl -L "https://dot.net/v1/dotnet-install.sh" -o /dotnet-install.sh \
    && chmod +x /dotnet-install.sh \
    && apt-get clean \
    && /dotnet-install.sh -c 5.0 --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet


ENTRYPOINT /bin/bash
