#!/bin/bash

# package name
packageName=''
case $TARGETARCH in
"amd64")
    $packageName='linux-x64.tar.gz'
    ;;
"arm64")
    $packageName='linux-arm64.tar.gz'
    ;;
esac

# version
version=$PS_VERSION

# download url
#    https://github.com/PowerShell/PowerShell/releases/download/v7.3.0/powershell-7.3.0-linux-arm64.tar.gz
url="https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${packageName}"

# install
curl -L -o /tmp/powershell.tar.gz ${PS_PACKAGE_URL} &&
    mkdir -p /opt/microsoft/powershell/7 &&
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 &&
    rm -rf /tmp/powershell.tar.gz &&
    chmod +x /opt/microsoft/powershell/7/pwsh &&
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
