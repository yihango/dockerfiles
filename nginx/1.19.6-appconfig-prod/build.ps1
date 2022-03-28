docker build . --force-rm -t staneee/nginx:1.19.6-appconfig-prod  -f ./Dockerfile
docker push staneee/nginx:1.19.6-appconfig-prod
