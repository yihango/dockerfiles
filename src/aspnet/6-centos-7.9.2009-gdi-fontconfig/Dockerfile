FROM --platform=$TARGETPLATFORM centos:7.9.2009 AS base

# install dotnet 6
RUN yum install -y wget icu \
    && wget https://dot.net/v1/dotnet-install.sh -O /dotnet-install.sh \
    && chmod +x /dotnet-install.sh \
    && /dotnet-install.sh --channel 6.0 --runtime aspnetcore --install-dir /usr/share/dotnet \
    && ln -s -f /usr/share/dotnet/dotnet /usr/bin/dotnet

# install gdi+/fontconfig
RUN yum install -y fontconfig libgdiplus \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll

# install openldap
RUN yum install -y openldap openldap-clients openldap-servers