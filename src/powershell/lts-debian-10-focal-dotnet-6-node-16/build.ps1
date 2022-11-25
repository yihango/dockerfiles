docker buildx build --platform 'linux/arm64,linux/amd64' -t staneee/powershell:lts-debian-10-focal-dotnet-6-node-16 -f ./Dockerfile . --push
