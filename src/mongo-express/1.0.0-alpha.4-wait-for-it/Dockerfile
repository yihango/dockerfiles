FROM mongo-express:1.0.0-alpha.4


WORKDIR /node_modules/mongo-express

COPY ./wait-for-it.sh  .

ENV WAITHOST=mongo WAITPORT=27017
RUN chmod +x wait-for-it.sh

ENTRYPOINT ./wait-for-it.sh $WAITHOST:$WAITPORT --timeout=0 \
    && /sbin/tini -- /docker-entrypoint.sh mongo-express
