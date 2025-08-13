#!/bin/bash

# Backup the original file
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak


# Add the new setting
echo "net.ipv4.ip_local_reserved_ports = 7002,10698,20000-32500,40000-45200,60000-60200" | sudo tee -a /etc/sysctl.conf

# Apply changes
sudo sysctl -p
