#!/bin/bash
#
#
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
echo "ADD/DELETE USER ON REMOTE SERVER/S"
echo "---------------------------------"

read -p "Adding or deleting a user? (add/delete): " adduser_deletuser
echo "--------------------------------------------"
echo ""
echo "---------------------------------------------"

echo "---------------------------------------------"
read -p "Are you sure your choice above? (yes/no): " confirm

confirm="${confirm,,}"

if [[ "$confirm" == "no" ]]; then
    echo "Exiting since not sure..."
    exit 1
elif [[ "$confirm" != "yes" ]]; then
    echo "Invalid input. Please enter yes or no."
    exit 1
fi

# Server List
echo "Please paste remote server/s"
echo "-------------------------------"
source $REMOTE_PATH/back/variables/create-server-list.sh

# Read the server list into an array
mapfile -t servers < $SERVER_LIST

# Choose user to execute with
export REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
source $REMOTE_PATH/back/select-run-user.sh
source $RUN_USER

# Add user
if [[ "$adduser_deletuser" == "add" ]]; then
     echo "Adding a user..."
     # Add remote script execution commands here
     read -p "Enter the new user's username: " USER_NAME
     read -p "Create password for user $USER_NAME : " PASS_WORD
     for host in "${servers[@]}"; do
             echo "Processing $host..."
	     plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "sudo useradd '$USER_NAME'; echo '$PASS_WORD' | sudo passwd --stdin '$USER_NAME'"
     done
else
        echo "Option is to delete a user on host/s above"
fi

# Delete user
if [[ "$adduser_deletuser" == "delete" ]]; then
     echo "Deleting a user..."
     # Add remote script execution commands here
     read -p "Enter user are deleting: " USER_NAME
     for host in "${servers[@]}"; do
             echo "Processing $host..."
             plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "sudo userdel -r '$USER_NAME'"
     done
else
        echo "Option was to add a user on $host"
fi
