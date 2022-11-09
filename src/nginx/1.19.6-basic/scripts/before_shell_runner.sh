#!/bin/bash

# create shell file dir
mkdir /beforeshell

# create before_shell.sh
cat >/beforeshell/before_shell.sh <<EOF
#!/bin/bash
${RUN_BEFORE_SHELL}
EOF

# goto beforeshell
cd /beforeshell || exit

# run before_shell.sh
/bin/bash ./before_shell.sh
