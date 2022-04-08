FROM nginx:1.19.6


# appconfig.prod.json content
ENV APPCONFIG=''

# copy before shell runner
WORKDIR /
COPY ./before_shell_runner.sh .
RUN chmod +x ./before_shell_runner.sh

# entrypoint
ENTRYPOINT /before_shell_runner.sh \
    && nginx -g "daemon off;"