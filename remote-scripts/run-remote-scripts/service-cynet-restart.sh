#!/bin/bash
#
# Restart Cynet
#

sudo systemctl stop cyservice
sudo systemctl start cyservice
sudo systemctl status cyservice 

