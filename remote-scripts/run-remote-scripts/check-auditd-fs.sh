#!/bin/bash
sudo cat /etc/fstab | grep audit
#sudo sed -i 's/^max_log_file_action = keep_logs/max_log_file_action = rotate/' /etc/audit/auditd.conf
