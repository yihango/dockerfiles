FROM --platform=$TARGETPLATFORM nginx:1.19.6

# copy scripts
COPY ./scripts/  /

# wait for it
ENV NGINX_WAITHOST=localhost NGINX_WAITPORT=80

# before shell content
ENV RUN_BEFORE_SHELL=''

# chmod +x scripts
RUN chmod + x /before_shell_appconfig_prod.sh \
    && chmod + x /before_shell_runner.sh \
    && chmod + x /wait-for-it.sh

ENTRYPOINT nginx -g 'daemon off;'