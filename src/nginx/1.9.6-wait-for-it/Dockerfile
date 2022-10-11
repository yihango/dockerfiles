FROM nginx:1.19.6


COPY ./wait-for-it.sh  .

ENV NGINX_WAITHOST=localhost NGINX_WAITPORT=80


ENTRYPOINT chmod +x wait-for-it.sh \
    && ./wait-for-it.sh $NGINX_WAITHOST:$NGINX_WAITPORT --timeout=0 \
    &&  nginx -g 'daemon off;'