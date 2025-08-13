#!/bin/bash
# 
allow_command="systemctl restart auditd"
USER_NAME="hposs"
# echo "Allowing sudo $allow_command for user $USER_NAME"

echo "$USER_NAME ALL=(ALL) NOPASSWD: $allow_command" | sudo tee /etc/sudoers.d/$USER_NAME > /dev/null
