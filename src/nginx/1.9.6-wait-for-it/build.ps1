docker build . --force-rm -t staneee/nginx:1.9.6-wait-for-it  -f ./Dockerfile
docker push staneee/nginx:1.9.6-wait-for-it
