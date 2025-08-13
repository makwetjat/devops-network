#!/bin/bash
subscription-manager list
yum clean all
subscription-manager unregister
subscription-manager clean
subscription-manager register --org=Openserve --activationkey=17023952
yum erase katello-agent -y
yum –disablerepo=* --enablerepo=rhel* --enablerepo=satellite* install katello-host-tools insights-client
