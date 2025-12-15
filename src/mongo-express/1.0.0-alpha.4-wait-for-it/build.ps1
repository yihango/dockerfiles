docker build . --force-rm -t ltm0203/mongo-express:1.0.0-alpha.4-wait-for-it  -f ./Dockerfile
docker push ltm0203/mongo-express:1.0.0-alpha.4-wait-for-it
