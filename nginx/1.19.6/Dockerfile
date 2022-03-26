FROM nginx:1.19.6


# before shell content
ENV RUN_BEFORE_SHELL=''

# copy before shell runner
WORKDIR /
COPY ./before_shell_runner.sh .
RUN chmod +x ./before_shell_runner.sh

# entrypoint
ENTRYPOINT /before_shell_runner.sh \
    && nginx -g "daemon off;"