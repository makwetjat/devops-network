#!/bin/bash
#
service_name="sshd"
echo "Restarting $service_name"
sudo systemctl restart $service_name
sudo systemctl status $service_name
