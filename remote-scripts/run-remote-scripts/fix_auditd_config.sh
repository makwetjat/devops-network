#!/bin/bash

CONFIG_FILE="/etc/audit/auditd.conf"
BACKUP_FILE="/etc/audit/auditd.conf.bak.$(date +%F_%H%M%S)"

# Backup the current config
cp -p "$CONFIG_FILE" "$BACKUP_FILE"
echo "Backup of auditd.conf saved to: $BACKUP_FILE"

# Ensure correct max_log_file_action
if grep -qi '^max_log_file_action' "$CONFIG_FILE"; then
    sed -i 's/^max_log_file_action.*/max_log_file_action = rotate/' "$CONFIG_FILE"
else
    echo "max_log_file_action = rotate" >> "$CONFIG_FILE"
fi

# Ensure correct admin_space_left_action
if grep -qi '^admin_space_left_action' "$CONFIG_FILE"; then
    sed -i 's/^admin_space_left_action.*/admin_space_left_action = rotate/' "$CONFIG_FILE"
else
    echo "admin_space_left_action = rotate" >> "$CONFIG_FILE"
fi

echo "auditd.conf updated successfully."

