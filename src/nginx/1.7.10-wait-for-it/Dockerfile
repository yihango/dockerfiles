FROM nginx:1.17.10


COPY ./wait-for-it.sh  .

ENV NGINX_WAITHOST=localhost NGINX_WAITPORT=80


ENTRYPOINT chmod +x wait-for-it.sh \
    && ./wait-for-it.sh $NGINX_WAITHOST:$NGINX_WAITPORT --timeout=0 \
    && /docker-entrypoint.sh nginx -g daemon off;