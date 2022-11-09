docker buildx build --platform 'linux/arm64,linux/amd64' -t staneee/powershell:lts-debian-10-focal-node-14  -f ./Dockerfile . --push
