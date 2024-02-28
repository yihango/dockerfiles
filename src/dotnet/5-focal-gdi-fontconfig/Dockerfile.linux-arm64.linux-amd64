# FROM --platform=$TARGETPLATFORM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
FROM --platform=$TARGETPLATFORM mcr.microsoft.com/dotnet/sdk:5.0-focal AS base


# 安装fontconfig库，用于Pdf导出,安装gdi+ 用于excel
RUN apt-get update \
    && apt-get install -y fontconfig libgdiplus\
    && apt-get clean \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll