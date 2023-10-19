FROM --platform=$TARGETPLATFORM centos:7.9.2009 AS base


RUN yum install -y wget \
    && wget https://dot.net/v1/dotnet-install.sh -O /dotnet-install.sh \
    && chmod +x /dotnet-install.sh \
    && /dotnet-install.sh --channel 6.0 --runtime aspnetcore --install-dir /usr/share/dotnet \
    && ln -s -f /usr/share/dotnet/dotnet /usr/bin/dotnet

RUN yum install -y fontconfig libgdiplus \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll
