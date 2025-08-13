#!/bin/bash

CONFIG_FILE="/etc/audit/auditd.conf"
LOG_ACTION=$(sudo grep -i '^max_log_file_action' "$CONFIG_FILE" | awk -F= '{print tolower($2)}' | tr -d ' ')

if [[ "$LOG_ACTION" == "rotate" ]]; then
    echo "Remove auditd LVM"
    sudo ls -ltr /var/log/audit/
    sudo service auditd stop
    sudo umount /var/log/audit
    sudo lvremove /dev/vg_misc/audit -y
    sudo sed -i '/audit/s/^/#/' /etc/fstab
    sudo mount -a
    sudo service auditd start
    sudo ls -ltr /var/log/audit/
else
    echo "The parameter max_log_file_action is set to '$LOG_ACTION', not 'rotate'."
fi

