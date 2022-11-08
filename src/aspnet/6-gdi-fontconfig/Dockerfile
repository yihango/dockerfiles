FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base


# change source
# RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
#     && sed -i "s@http://ftp.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list \
#     && sed -i "s@http://security.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list


# 安装fontconfig库，用于Pdf导出,安装gdi+ 用于excel
RUN apt-get update \
    && apt-get install -y fontconfig libgdiplus\
    && apt-get clean \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll
