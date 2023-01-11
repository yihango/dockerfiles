docker buildx build --platform 'linux/arm64,linux/amd64' -t staneee/ntp:chrony  -f ./Dockerfile . --push
