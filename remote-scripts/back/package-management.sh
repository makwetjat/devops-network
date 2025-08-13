#!/bin/bash
#
#  README
#  When installing a package... Both questions must yes.
#  Every package has it's own remote script for installation
#  When only runnning a remote script, no and yes.
#
# Check if all required arguments are provided
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
echo "ABOUT TO RUN SCRIPT ON REMOTE SERVERS"
echo " "
# Server List
SERVER_LIST="$REMOTE_PATH/remote-servers/server_list.txt"         # List of Servers
# Read the server list into an array
mapfile -t servers < $SERVER_LIST
# Choose user to execute with
export REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
source $REMOTE_PATH/back/select-run-user.sh
source $RUN_USER

echo " "
read -p "Are you Installing RPM? (yes/no): " installing_rpm
echo " "

if [[ "$installing_rpm" == "yes" ]]; then
     echo "Choose script to execute: Your choice should be the script number"
     source $REMOTE_PATH/back/select-remote-script.sh
     SCRIPT_NAME=$(basename "$COMMAND_SCRIPT")
     echo "Running remote script..."
     # Add remote script execution commands here
     for host in "${servers[@]}"; do
             echo "Processing $host..."
	     pscp -l "$REMOTE_USER" -pw "$REMOTE_PASS" "$COMMAND_SCRIPT" "$host:/tmp/$SCRIPT_NAME"
	     plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "bash /tmp/$SCRIPT_NAME; rm -f /tmp/$SCRIPT_NAME"
     done
else
        echo "Skipping rpm installation"
fi

echo " "
read -p "Are you Removing RPM? (yes/no): " removing_rpm
echo " "

if [[ "$removing_rpm" == "yes" ]]; then
     read -p "Enter the name of the rpm package to be removed: " rpm_name 
     echo ""
     cd $REMOTE_PATH/run-remote-scripts/hardcoded/
     sed -i "s/^rpm_name=.*/rpm_name=\"$rpm_name\"/" $REMOTE_PATH/run-remote-scripts/hardcoded/remove-rpm.sh
     source $REMOTE_PATH/back/variables/rpm-remove-variables
     SCRIPT_NAME=$(basename "$COMMAND_SCRIPT")
     echo "Running remote script..."
     # Add remote script execution commands here
     for host in "${servers[@]}"; do
             echo "Processing $host..."
             pscp -l "$REMOTE_USER" -pw "$REMOTE_PASS" "$COMMAND_SCRIPT" "$host:/tmp/$SCRIPT_NAME"
             plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "rpm_name=$rpm_name; bash /tmp/$SCRIPT_NAME; rm -f /tmp/$SCRIPT_NAME"
     done
else
        echo "Skipping rpm removal"
fi
