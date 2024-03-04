```shell
docker buildx build \
  --platform 'linux/arm64,linux/amd64,windows/amd64' \
  -t '' \
  -f ./Dockerfile . --push

docker buildx build \
  --platform 'windows/amd64' \
  -t 'test:windows-amd64' \
  -f ./Dockerfile.windows-amd64 . --push
```