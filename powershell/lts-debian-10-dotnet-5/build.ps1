docker build . --force-rm -t staneee/powershell:lts-debian-10-dotnet-5  -f ./Dockerfile
docker push staneee/powershell:lts-debian-10-dotnet-5

docker tag staneee/powershell:lts-debian-10-dotnet-5 registry.cn-shanghai.aliyuncs.com/staneee/powershell:lts-debian-10-dotnet-5
docker push registry.cn-shanghai.aliyuncs.com/staneee/powershell:lts-debian-10-dotnet-5
