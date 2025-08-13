#!/bin/bash
#
#  README
#  
# Restart Services 
#  
#
# Check if all required arguments are provided
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
echo "RESTARTING SERVICE ON REMOTE SERVERS"
echo " "
# Server List
echo "Please paste a list of remote servers"
source $REMOTE_PATH/back/variables/create-server-list.sh
#
# Read the server list into an array
mapfile -t servers < $SERVER_LIST
# Choose user to execute with
export REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
source $REMOTE_PATH/back/select-run-user.sh
source $RUN_USER

echo " "
read -p "Are you restarting a service? (yes/no): " restart_service
echo " "

if [[ "$restart_service" == "yes" ]]; then
     read -p "Enter the service name: " service_name
     echo ""
     cd $REMOTE_PATH/run-remote-scripts/hardcoded
     sed -i "s/^service_name=.*/service_name=\"$service_name\"/" $REMOTE_PATH/run-remote-scripts/hardcoded/restart-services.sh
     source $REMOTE_PATH/back/variables/service-variables
     SCRIPT_NAME=$(basename "$COMMAND_SCRIPT")
     echo "Running remote script..."
     # Add remote script execution commands here
     for host in "${servers[@]}"; do
             echo "Processing $host..."
             pscp -l "$REMOTE_USER" -pw "$REMOTE_PASS" "$COMMAND_SCRIPT" "$host:/tmp/$SCRIPT_NAME"
             plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "service_name=$service_name; bash /tmp/$SCRIPT_NAME; rm -f /tmp/$SCRIPT_NAME"
     done
else
        echo "Skipping service restart"
fi

