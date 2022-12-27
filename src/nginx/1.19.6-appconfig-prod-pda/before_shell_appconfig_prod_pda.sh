#!/bin/bash

# create before_shell.sh
cat >/usr/share/nginx/html/static/assets/appconfig.prod.json <<EOF
${APPCONFIG}
EOF
