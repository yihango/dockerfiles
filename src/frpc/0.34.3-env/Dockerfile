FROM --platform=$TARGETPLATFORM snowdreamtech/frpc:0.34.3

# before shell content
ENV FRPC_INI=''

# copy before shell runner
WORKDIR /
COPY ./before_shell_runner.sh .
RUN chmod +x ./before_shell_runner.sh

# entrypoint
ENTRYPOINT /before_shell_runner.sh \
    && /usr/bin/frpc -c /frpc.ini