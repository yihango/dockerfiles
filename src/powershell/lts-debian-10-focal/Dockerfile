#FROM --platform=$TARGETPLATFORM debian:buster-slim
FROM --platform=$BUILDPLATFORM debian:buster-slim

# pwsh version and download url
ARG PS_VERSION=7.2.7

# change source
# RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
#   && sed -i "s@http://deb.debian.org@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
#   && sed -i "s@http://deb.debian.org@http://repo.huaweicloud.com@g" /etc/apt/sources.list

# install baisc depends
RUN apt-get update\
  && apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  less \
  locales \
  gss-ntlmssp \
  libicu63 \
  libssl1.1 \
  libc6 \
  libgcc1 \
  libgssapi-krb5-2 \
  libstdc++6 \
  zlib1g \
  openssh-client \
  # locale.gen
  && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
  && locale-gen && update-locale  

# install powershell
COPY ./pwsh-install.sh /root/pwsh-install.sh
RUN chmod +x /root/pwsh-install.sh \
  && /root/pwsh-install.sh "${PS_VERSION}"

# clear apt
RUN apt-get dist-upgrade -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*  

ENTRYPOINT /bin/bash
