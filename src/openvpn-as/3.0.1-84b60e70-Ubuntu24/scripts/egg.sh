#!/bin/bash

#
source_dir="/openvpn/egg"
target_dir="/usr/local/openvpn_as/lib/python"

#
if [ ! -d "$source_dir" ]; then
    mkdir "$source_dir"
fi

#
if [ ! -d "$target_dir" ]; then
    echo "error: not found $target_dir"
    exit 0
fi

# find first .egg
first_egg_file=$(find "$source_dir" -maxdepth 1 -name "*.egg" -type f | head -n 1)

if [ -z "$first_egg_file" ]; then
    echo "error: not found file .egg "
    exit 0
fi

echo "info: .egg file $first_egg_file"
echo "info: copy to $target_dir"

# copy file
cp -f "$first_egg_file" "$target_dir/"

if [ $? -eq 0 ]; then
    echo "success: copy success $(basename "$first_egg_file")"
else
    echo "error: copy fail $(basename "$first_egg_file")"
    exit 0
fi
