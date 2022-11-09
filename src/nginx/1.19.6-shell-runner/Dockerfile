FROM --platform=$TARGETPLATFORM staneee/nginx:1.19.6-basic

# before shell content
ENV RUN_BEFORE_SHELL=''

# entrypoint
ENTRYPOINT /before_shell_runner.sh \
    && nginx -g "daemon off;"