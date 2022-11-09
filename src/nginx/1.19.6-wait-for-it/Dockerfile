FROM --platform=$TARGETPLATFORM staneee/nginx:1.19.6-basic


ENV NGINX_WAITHOST=localhost NGINX_WAITPORT=80


ENTRYPOINT ./wait-for-it.sh $NGINX_WAITHOST:$NGINX_WAITPORT --timeout=0 \
    &&  nginx -g 'daemon off;'