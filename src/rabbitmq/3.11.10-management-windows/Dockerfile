# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS installer

WORKDIR /installer-packages
COPY ./packages .

RUN powershell -Command " `
New-Item -Type Directory -Path '/otp'; `
Expand-Archive -Path '/installer-packages/otp_win64_25.3.2.9.exe.zip' -DestinationPath '/otp'"

RUN powershell -Command " `
New-Item -Type Directory -Path '/rabbitmq'; `
Expand-Archive -Path '/installer-packages/rabbitmq_server-3.11.10.zip' -DestinationPath '/rabbitmq'"

# run image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

COPY --from=installer ["/otp", "/otp"]
COPY --from=installer ["/rabbitmq", "/rabbitmq"]

RUN start /w C:/otp/otp_win64_25.3.2.9.exe /S /D=C:\erlang && rmdir C:\otp /s /q

ENV ERLANG_HOME=C:\erlang `
    RABBITMQ_BASE=C:\rabbitmq\data

RUN setx /M PATH "%PATH%;%ERLANG_HOME%\bin"

RUN c:\rabbitmq\sbin\rabbitmq-plugins.bat enable rabbitmq_management --offline

USER ContainerAdministrator

RUN ["cmd", "/c", "echo loopback_users.guest = false> C:\\rabbitmq\\data\\rabbitmq.conf"]

EXPOSE 5672 15672 15673

CMD "c:\rabbitmq\sbin\rabbitmq-server.bat"
