#!/bin/bash
#
#
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
echo "------------------------------------"
echo "Allowing a user to run sudo command"
echo "------------------------------------"
echo ""

# Server List
echo "-------------------------------"
echo "Please paste remote server/s"
echo "-------------------------------"
echo ""
source $REMOTE_PATH/back/variables/create-server-list.sh
echo ""
# Read the server list into an array
mapfile -t servers < $SERVER_LIST

# Choose user to execute with
echo ""
export REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
source $REMOTE_PATH/back/select-run-user.sh
source $RUN_USER
echo ""
echo "-------------------------------------------------------------------"
read -p "Are you sure you want to give a user rights to run a sudo command? (yes/no): " sudo_command
echo "-------------------------------------------------------------------"

if [[ "$sudo_command" == "yes" ]]; then
     echo "------------------------------------------------------"
     read -p "Enter username you are allowing to run sudo command: " USER_NAME
     echo ""
     echo "------------------------------------------------------"
     echo ""
     echo "Example, Just type - systemctl restart httpd... If want to allow sudo systemctl restart httpd"
     echo ""
     read -p "Enter command line to allow sudo for $USER_NAME: " allow_command
     echo ""
      echo "-------------------------------------------------"
     cd $REMOTE_PATH/run-remote-scripts/hardcoded/
     sed -i "s/^allow_command=.*/allow_command=\"$allow_command\"/" $REMOTE_PATH/run-remote-scripts/hardcoded/allow-sudo-command.sh
     sed -i "s/^USER_NAME=.*/USER_NAME=\"$USER_NAME\"/" $REMOTE_PATH/run-remote-scripts/hardcoded/allow-sudo-command.sh
     source $REMOTE_PATH/back/variables/allow-sudo-variables
     SCRIPT_NAME=$(basename "$COMMAND_SCRIPT")
     echo "Running remote script..."
     # Add remote script execution commands here
     for host in "${servers[@]}"; do
             echo "Processing $host..."
             pscp -l "$REMOTE_USER" -pw "$REMOTE_PASS" "$COMMAND_SCRIPT" "$host:/tmp/$SCRIPT_NAME"
             plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "allow_command=$allow_command; bash /tmp/$SCRIPT_NAME; rm -f /tmp/$SCRIPT_NAME"
     done
else
        echo "Skipping to give a user sudo rights to run a command"
fi

