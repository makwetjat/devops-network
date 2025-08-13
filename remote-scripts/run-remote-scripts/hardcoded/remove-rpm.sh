#!/bin/bash
# 
rpm_name="firefox"
echo "Removing $rpm_name"
sudo yum remove $rpm_name -y
