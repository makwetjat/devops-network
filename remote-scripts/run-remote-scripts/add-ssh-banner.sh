#!/bin/bash
#
## Incase there are existing banners - clear and create
sudo truncate -s 0 /etc/motd
sudo truncate -s 0 /etc/sshbanner.txt
sudo tee /etc/sshbanner.txt > /dev/null <<EOF
*****************************************************************************
*                  S Y S T E M   U S A G E   A G R E E M E N T              *
*****************************************************************************
*                               T E L K O M                                 *
*****************************************************************************
* WARNING!  This  is a private  system, and is  for the use  of authorized  *
* personnel only. If you have not been authorized to use this system,       *
* please disconnect now.                                                    *
*                                                                           *
* Your activities on this system must be in accordance with all applicable  *
* information security policies of the company.  By using this system, you  *
* agree that you have read, understood, and will abide by these policies.   *
*                                                                           *
* Individuals using  this computer system without authority,  or in excess  *
* of their  authority, are  subject to having  all of their  activities on  *
* this system monitored  and recorded by system personnel.   In the course  *
* of monitoring individuals improperly using this system, or in the course  *
* of system  maintenance, the activities  of authorized users may  also be  *
* monitored.   Anyone  using  this   system  expressly  consents  to  such  *
* monitoring  and is  advised  that if  such  monitoring reveals  possible  *
* evidence of criminal activity, system personnel may provide the evidence  *
* of such monitoring to law enforcement officials.                          *
*                                                                           *
*****************************************************************************
EOF
sudo sed -i 's/^#Banner.*/Banner \/etc\/sshbanner.txt/' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo systemctl status sshd
