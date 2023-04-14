#!/bin/bash

# create before_shell.sh
if [ -n "${APPCONFIG}" ]; then
  cat <<EOF > /usr/share/nginx/html/assets/appconfig.prod.json
${APPCONFIG}
EOF
fi