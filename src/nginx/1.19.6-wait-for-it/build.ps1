docker buildx build --platform 'linux/arm64,linux/amd64' -t staneee/nginx:1.19.6-wait-for-it -f ./Dockerfile . --push
