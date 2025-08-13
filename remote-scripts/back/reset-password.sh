#!/bin/bash
#
#
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
echo "RESET PASSWORD ON REMOTE SERVER/S"
echo "---------------------------------"

# Server List
echo ""
echo "Please paste remote server/s"
echo "-------------------------------"
source $REMOTE_PATH/back/variables/create-server-list.sh

# Read the server list into an array
mapfile -t servers < $SERVER_LIST

echo ""
echo ""
# Choose user to execute with
export REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
source $REMOTE_PATH/back/select-run-user.sh
source $RUN_USER

echo " "
read -p "Are you sure you want to reset password? (yes/no): " passwd_reset
echo " "

echo ""
echo "--------------------------------------------------------------"
read -p "Enter username you are changing the password for: " USER_NAME
echo ""
echo "--------------------------------------------------------------"
read -p "Enter new password for user $USER_NAME : " PASS_WORD
echo "--------------------------------------------------------------"
echo ""

if [[ "$passwd_reset" == "yes" ]]; then
     echo "Running remote command..."
     # Add remote script execution commands here
     for host in "${servers[@]}"; do
             echo "Processing $host..."
	     plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "echo '$PASS_WORD' | sudo passwd --stdin '$USER_NAME'"
     done
else
        echo "Skipping password reset for $host"
fi
