#!/bin/bash

declare -A user_files=(
    [ansible]="$REMOTE_PATH/secrets/.ansible.user"
    [root]="$REMOTE_PATH/secrets/.root.user"
)

echo "CHOOSE YOUR REMOTE USER... 2 Choices (ansible/root)"
read -r USER

case "$USER" in
    ansible|root) FILE="${user_files[$USER]}" ;;
    *) echo "Invalid user"; exit 1 ;;
esac

RUN_USER=$FILE

