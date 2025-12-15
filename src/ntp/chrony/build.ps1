docker buildx build --platform 'linux/arm64,linux/amd64' -t ltm0203/ntp:chrony  -f ./Dockerfile . --push
