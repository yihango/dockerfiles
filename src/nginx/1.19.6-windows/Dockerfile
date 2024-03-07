# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2022

WORKDIR /installer-packages
COPY ./nginx-1.19.6.zip .

RUN powershell -Command " `
New-Item -Type Directory -Path '/nginx'; `
Expand-Archive -Path '/installer-packages/nginx-1.19.6.zip' -DestinationPath '/nginx'"

WORKDIR /nginx

USER ContainerAdministrator

# start
EXPOSE 80
CMD ["nginx.exe"]