docker build . --force-rm -t staneee/nginx:1.7.10-wait-for-it  -f ./Dockerfile
docker push staneee/nginx:1.7.10-wait-for-it
