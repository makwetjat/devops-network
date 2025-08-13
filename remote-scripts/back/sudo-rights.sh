#!/bin/bash
#
#
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
echo "-----------------------------"
echo "Adding a user to sudoers list"
echo "-----------------------------"
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
read -p "Are you sure you want to give a user sudo/admin rights? (yes/no): " sudo_rights
echo "-------------------------------------------------------------------"

echo ""
read -p "Enter username you are giving admin rights to: " USER_NAME
echo ""

if [[ "$sudo_rights" == "yes" ]]; then
     echo "Running remote command..."
     # Add remote script execution commands here
     for host in "${servers[@]}"; do
             echo "Processing $host..."
	     plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "echo '$USER_NAME ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/$USER_NAME > /dev/null && sudo chmod 440 /etc/sudoers.d/$USER_NAME"
	     echo "-------------------------------------------------------------------"
	     echo "User $USER_NAME added to sudoers list"
     done
else
        echo "Skipping sudo rights access on $host"
fi
