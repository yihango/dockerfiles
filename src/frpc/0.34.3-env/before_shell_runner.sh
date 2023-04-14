#!/bin/sh

# create frpc.ini
if [ -n "${FRPC_INI}" ]; then
  cat <<EOF > /frpc.ini
${FRPC_INI}
EOF
fi