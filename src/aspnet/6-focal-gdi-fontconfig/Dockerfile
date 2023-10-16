# FROM --platform=$TARGETPLATFORM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
FROM --platform=$TARGETPLATFORM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base


# change source
# RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
#     && sed -i "s@http://ftp.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list \
#     && sed -i "s@http://security.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list


# 安装fontconfig库，用于Pdf导出,安装gdi+ 用于excel
RUN apt-get update \
    && apt-get install -y fontconfig libgdiplus \
    && apt-get install -y --no-install-recommends libldap-2.4-2 \
    && apt-get install -y --no-install-recommends libldap-common \
    && apt-get clean \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll \
    && mkdir /usr/lib/x86_64-linux-gnu \
    && ln -s -f /usr/lib/x86_64-linux-gnu/libldap-2.4.so.2 /usr/lib/x86_64-linux-gnu/libldap.so.2 \
    && ln -s -f /usr/lib/x86_64-linux-gnu/liblber-2.4.so.2 /usr/lib/x86_64-linux-gnu/liblber.so.2


