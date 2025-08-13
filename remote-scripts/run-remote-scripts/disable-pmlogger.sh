#!/bin/bash
#
sudo systemctl disable pmlogger
sudo systemctl stop pmlogger
sudo rm -rf /var/log/pcp/*
# That's all folks
#
