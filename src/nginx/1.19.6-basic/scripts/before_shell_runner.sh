#!/bin/bash

# create shell file dir
mkdir /beforeshell

# create before_shell.sh
if [ -n "${RUN_BEFORE_SHELL}" ]; then
  cat <<EOF > /beforeshell/before_shell.sh
#!/bin/bash
${RUN_BEFORE_SHELL}
EOF
fi

# goto beforeshell dir
cd /beforeshell || exit

# run before_shell.sh
if [ -e ./before_shell.sh ]; then
    /bin/bash ./before_shell.sh
fi

