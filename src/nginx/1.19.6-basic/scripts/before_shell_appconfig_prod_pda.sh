#!/bin/bash

# create appconfig.prod.json
if [ -n "${APPCONFIG}" ]; then
  cat <<EOF > /usr/share/nginx/html/static/assets/appconfig.prod.json
${APPCONFIG}
EOF
fi