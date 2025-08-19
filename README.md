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


<!---  # Load balancing # -->
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
<!-- All the web files are part of the repository -->

<!-- Add this to reverse-proxy.conf: -->

<VirtualHost *:80>
    ServerName opsautodeploy.configwave.co.za
    ServerAlias 192.168.101.207
    ServerAlias 172.16.206.41
    ServerAlias localhost

   DocumentRoot "/app/devops-network/loadbalancer"

   <Directory "/app/devops-network/loadbalancer">
        AllowOverride None
        Require all granted
    </Directory>

    ProxyPreserveHost On
    ProxyPass "/remotescripts/ws" "ws://localhost:8000/ws"
    ProxyPassReverse "/remotescripts/ws" "ws://localhost:8000/ws"
    ProxyPass /remotescripts/ http://localhost:8000/
    ProxyPassReverse /remotescripts/ http://localhost:8000/

    ErrorLog /var/log/httpd/autoscripts-error.log
    CustomLog /var/log/httpd/autoscripts-access.log combine
</VirtualHost>

# Restart Apache
sudo systemctl restart httpd


#

