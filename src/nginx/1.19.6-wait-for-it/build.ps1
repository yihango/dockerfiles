docker buildx build --platform 'linux/arm64,linux/amd64' -t ltm0203/nginx:1.19.6-wait-for-it -f ./Dockerfile . --push
