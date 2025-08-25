<!-- ## ## Automation UI FastAPI Service  ## ## A ----->
<!--
# devops-network
- First release - prototype testing
## ##########################
## How to commit big files ## 
## ##########################
1. Copy or move the large file into your repo
Example:
C:\Users\makwetjat\Videos\devnetwork-repos\devops-network\installations\Symantec-SESC.tgz

2. Then run the Git LFS tracking, add, commit, and push steps:
powershell
git lfs track "installations/Symantec-SESC.tgz"
git add .gitattributes
git add installations/Symantec-SESC.tgz
git commit -m "Add Symantec-SESC.tgz via LFS"
git push origin main

N.B - Once it’s inside the repo, Git LFS will handle it correctly — no need to keep it elsewhere

# Install all required packages for new builds as per linux-deploy.txt

<!-- ## ## Automation UI FastAPI Service  ## ## A ----->


<!---  # Load balancing 
# Install Apache modules
sudo dnf install httpd -y
sudo systemctl enable --now httpd

# Enable proxy modules
sudo dnf install mod_proxy_html -y   # optional for HTML rewriting
sudo sed -i '/#LoadModule proxy_module/s/^#//' /etc/httpd/conf.modules.d/00-proxy.conf
sudo sed -i '/#LoadModule proxy_http_module/s/^#//' /etc/httpd/conf.modules.d/00-proxy.conf
sudo sed -i '/#LoadModule proxy_wstunnel_module /s/^#//' /etc/httpd/conf.modules.d/00-proxy.conf

# Remove default redhat welcome page
sudo mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak

# Configure reverse proxy

Create /etc/httpd/conf.d/reverse-proxy.conf
<> All the web files are part of the repository

 Add this to reverse-proxy.conf:

[root@opsautodeploy ~]# cat /etc/httpd/conf.d/reverse-proxy.conf
<VirtualHost *:80>
    ServerName opsautodeploy.configwave.co.za
    ServerAlias 192.168.101.207
    ServerAlias 192.168.188.90
    ServerAlias 172.16.206.46
    ServerAlias localhost

   DocumentRoot "/app/devops-network/loadbalancer"

   <Directory "/app/devops-network/loadbalancer">
        AllowOverride None
        Require all granted
    </Directory>

    ProxyPreserveHost On
    # Forward WebSocket
    ProxyPass "/remotescripts/ws" "ws://localhost:8000/ws"
    ProxyPassReverse "/remotescripts/ws" "ws://localhost:8000/ws"
    # Forward main app
    ProxyPass /remotescripts/ http://localhost:8000/
    ProxyPassReverse /remotescripts/ http://localhost:8000/

    ErrorLog /var/log/httpd/autoscripts-error.log
    CustomLog /var/log/httpd/autoscripts-access.log combine
</VirtualHost>

# Ansible UI

# Semaph
<VirtualHost *:80>
    ServerName ansible.configwave.co.za
    ServerAlias 192.168.101.207
    ServerAlias 192.168.188.90
    ServerAlias 172.16.206.46
    ServerAlias localhost

    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    ErrorLog /var/log/httpd/semaphore-error.log
    CustomLog /var/log/httpd/semaphore-access.log combined
</VirtualHost>

# Account hub
<VirtualHost *:80>
    ServerName accounts-hub.configwave.co.za
    ServerAlias 192.168.101.207
    ServerAlias 192.168.188.90
    ServerAlias 172.16.206.46
    ServerAlias localhost

    ProxyPreserveHost On
    # Forward WebSocket
    ProxyPass "/accountshub/ws" "ws://localhost:8001/ws"
    ProxyPassReverse "/accountshub/ws" "ws://localhost:8001/ws"
    # Forward main app
    ProxyPass /accountshub/ http://localhost:8001/
    ProxyPassReverse /accountshub/ http://localhost:8001/


    #ProxyPass / http://localhost:8001/
    #ProxyPassReverse / http://localhost:8001/

</VirtualHost>


<VirtualHost *:80>
    ServerName ansible-hub.configwave.co.za
    ServerAlias 192.168.101.207
    ServerAlias 192.168.188.90
    ServerAlias 172.16.206.46
    ServerAlias localhost

    ProxyPreserveHost On
    # Forward WebSocket
    ProxyPass "/ansiblehub/ws" "ws://localhost:8002/ws"
    ProxyPassReverse "/ansiblehub/ws" "ws://localhost:8002/ws"
    # Forward main app
    ProxyPass /ansiblehub/ http://localhost:8002/
    ProxyPassReverse /ansiblehub/ http://localhost:8002/


</VirtualHost>
[root@opsautodeploy ~]#


# Restart Apache
sudo systemctl restart httpd
-->

#

