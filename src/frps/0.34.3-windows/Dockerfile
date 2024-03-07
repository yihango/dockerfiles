# escape=`

# install image
FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS installer

# copy package
WORKDIR /installer-packages
COPY ./frp_0.34.3_windows_amd64.zip .

# expand package
RUN powershell -Command " `
New-Item -Type Directory -Path '/frps'; `
Expand-Archive -Path '/installer-packages/frp_0.34.3_windows_amd64.zip' -DestinationPath '/frps'"

# run image
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022
WORKDIR /frps
COPY --from=installer ["/frps", "/frps"]

USER ContainerAdministrator

# start
EXPOSE 7000 7500
CMD ["frps.exe"]