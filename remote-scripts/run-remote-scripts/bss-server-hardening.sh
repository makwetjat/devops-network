#!/bin/bash
#
#
echo '$FileCreateMode 0644' | sudo tee -a /etc/rsyslog.conf
sudo systemctl restart rsyslog.service
#
#
sudo chmod 700 /etc/cron.daily
sudo chmod 700 /etc/cron.d
echo "root" | sudo tee -a /etc/cron.allow
echo "oracle" | sudo tee -a /etc/cron.allow
#
#
sudo chmod 600 /etc/ssh/ssh_host_ecdsa_key
sudo chmod 600 /etc/ssh/ssh_host_ed25519_key
sudo chmod 600 /etc/ssh/ssh_host_rsa_key

sudo sed -i 's/^ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config
sudo sed -i 's/^#LoginGraceTime.*/LoginGraceTime 1m/' /etc/ssh/sshd_config
sudo sed -i 's/^#Banner.*/Banner \/etc\/sshbanner.txt/' /etc/ssh/sshd_config

sudo tee /etc/sshbanner.txt > /dev/null <<EOF
*****************************************************************************
*                  S Y S T E M   U S A G E   A G R E E M E N T              *
*****************************************************************************
WARNING!  This  is a private  system, and is  for the use  of authorized
personnel only. If you have not been authorized to use this system,
please disconnect now.

Your activities on this system must be in accordance with all applicable
information security policies of the company.  By using this system, you
agree that you have read, understood, and will abide by these policies.

Individuals using  this computer system without authority,  or in excess
of their  authority, are  subject to having  all of their  activities on
this system monitored  and recorded by system personnel.   In the course
of monitoring individuals improperly using this system, or in the course
of system  maintenance, the activities  of authorized users may  also be
monitored.   Anyone  using  this   system  expressly  consents  to  such
monitoring  and is  advised  that if  such  monitoring reveals  possible
evidence of criminal activity, system personnel may provide the evidence
of such monitoring to law enforcement officials.

*****************************************************************************
EOF

sudo systemctl restart sshd

#
#

echo 'auth        required pam_faillock.so preauth silent unlock_time=900 even_deny_root fail_interval=900 deny=5' | sudo tee -a /etc/pam.d/password-auth
echo 'auth        required pam_faillock.so preauth silent unlock_time=900 even_deny_root fail_interval=900 deny=5' | sudo tee -a /etc/pam.d/system-auth

echo 'account     required                                     pam_faillock.so' | sudo tee -a /etc/pam.d/password-auth
echo 'account     required                                     pam_faillock.so' | sudo tee -a /etc/pam.d/system-auth

#
#
sudo sed -i 's/^PASS_MAX_DAYS\s\+365/PASS_MAX_DAYS     60/' /etc/login.defs
#
#
echo "TMOUT=600" | sudo tee -a /etc/profile /etc/bashrc

#
