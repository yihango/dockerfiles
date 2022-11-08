#!/bin/bash

# create before_shell.sh
cat >/usr/share/nginx/html/assets/appconfig.prod.json <<EOF
${APPCONFIG}
EOF
