#!/bin/bash

# 复制.egg文件的逻辑
source_dir="/openvpn/egg"
target_dir="/usr/local/openvpn_as/lib/python"

if [ -d "$source_dir" ] && [ -d "$target_dir" ]; then
    first_egg_file=$(find "$source_dir" -maxdepth 1 -name "*.egg" -type f | head -n 1)
    if [ -n "$first_egg_file" ]; then
        echo "info: copying .egg file: $first_egg_file"
        cp -f "$first_egg_file" "$target_dir/" 2>/dev/null && echo "success: copied successfully" || echo "error: copy failed"
    fi
fi