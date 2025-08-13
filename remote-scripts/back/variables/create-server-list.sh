#!/bin/bash
REMOTE_PATH="/apps/remote-scripts"
output_file="$REMOTE_PATH/remote-servers/server_list.txt"
> "$output_file"  # Clear the file first

while true; do
    read -p "Enter server name (or type 'done' to finish): " item
    if [[ "$item" == "done" ]]; then
        break
    fi
    echo "$item" >> "$output_file"
done
SERVER_LIST="$REMOTE_PATH/remote-servers/server_list.txt"         # List of Servers
