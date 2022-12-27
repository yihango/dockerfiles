FROM --platform=$TARGETPLATFORM staneee/nginx:1.19.6-basic

# appconfig.prod.json content
ENV APPCONFIG=''

COPY ./before_shell_appconfig_prod_pda.sh  /before_shell_appconfig_prod_pda.sh

# chmod +x scripts
RUN chmod +x /before_shell_appconfig_prod_pda.sh

# entrypoint
ENTRYPOINT /before_shell_appconfig_prod_pda.sh \
    && nginx -g "daemon off;"