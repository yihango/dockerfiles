docker buildx build --platform 'linux/arm64,linux/amd64' -t ltm0203/powershell:lts-debian-10-focal-docker-20-10-21-zip  -f ./Dockerfile . --push
