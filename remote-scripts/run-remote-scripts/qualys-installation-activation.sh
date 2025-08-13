#!/bin/bash
#
## QualysCloudAgent Installation
sudo rpm -Uvh /tmp/QualysCloudAgent.rpm
echo 'qualys_https_proxy=https://10.227.171.99:80' | sudo tee /etc/sysconfig/qualys-cloud-agent
sudo /usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=9c336514-41d2-4c9c-8355-6d2664b780f1 CustomerId=1f3817a5-baf3-d1c1-8363-5095ee9b111d ServerUri=https://qagpublic.qg1.apps.qualys.eu/CloudAgent/
sudo systemctl restart qualys-cloud-agent 
#
## That's all folks
