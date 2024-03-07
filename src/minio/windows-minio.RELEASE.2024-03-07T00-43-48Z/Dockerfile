# escape=`

# install image
FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS installer

# copy package
WORKDIR /installer-packages
COPY ./minio.zip .

# expand package
RUN powershell -Command " `
New-Item -Type Directory -Path '/minio'; `
Expand-Archive -Path '/installer-packages/minio.zip' -DestinationPath '/minio'"

# run image
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022
WORKDIR /minio
COPY --from=installer ["/minio", "/minio"]

USER ContainerAdministrator

# start
EXPOSE 8236
CMD ["minio.exe", "server", "C:\\minio\\data", "--console-address", ":8236"]
