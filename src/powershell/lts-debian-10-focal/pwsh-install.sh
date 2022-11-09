#!/bin/bash

build_arch=$1
ps_version=$2


echo $build_arch


# package name
ps_package=''
case $build_arch in
"amd64")
    $ps_package='linux-x64.tar.gz'
    ;;
"arm64")
    $ps_package='linux-arm64.tar.gz'
    ;;
esac

# download url
#    https://github.com/PowerShell/PowerShell/releases/download/v7.3.0/powershell-7.3.0-linux-arm64.tar.gz
ps_package_url="https://github.com/PowerShell/PowerShell/releases/download/v${ps_version}/powershell-${ps_version}-${ps_package}"

echo $ps_package_url

# install
curl -L -o /tmp/powershell.tar.gz "${ps_package_url}" &&
    mkdir -p /opt/microsoft/powershell/7 &&
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 &&
    rm -rf /tmp/powershell.tar.gz &&
    chmod +x /opt/microsoft/powershell/7/pwsh &&
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
