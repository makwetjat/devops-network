#!/bin/bash
#
#  README
#
# Security patching
#

# Define remote script base path
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"

echo "----------------------------------------"
echo "----------------------------------------"
echo "SECURITY PATCHING ON REMOTE SERVERS"
echo "----------------------------------------"
echo "----------------------------------------"

# Server List
echo "Please paste a list of remote servers"
source "$REMOTE_PATH/back/variables/create-server-list.sh"

# Read the server list into an array
mapfile -t servers < "$SERVER_LIST"

# Choose user to execute with
source "$REMOTE_PATH/back/select-run-user.sh"
source "$RUN_USER"

echo " "
read -p "Are you sure want to patch servers from the list above? (yes/no): " security_patching
echo " "

if [[ "$security_patching" == "yes" ]]; then
    echo "Running remote security patching commands..."
    for host in "${servers[@]}"; do
	echo "----------------------------------------"
        echo "----------------------------------------"
        echo "Processing $host..."
	echo "----------------------------------------"
	echo "----------------------------------------"
        # Execute script (may trigger reboot)
        #plink "$host" -l "$REMOTE_USER" -pw "$REMOTE_PASS" "sudo yum update -y && sudo init 6"
        plink "$host" -l "$REMOTE_USER" -pw "$REMOTE_PASS" "sudo yum update -y"
        echo "----------------------------------------"
	echo "Waiting for $host to go down..."
	echo "----------------------------------------"
        sleep 10
        # Wait until the server becomes unreachable (goes down)
        while plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "exit" &>/dev/null; do
            sleep 5
        done
	echo "----------------------------------------"
        echo "$host is rebooting..."
	echo "----------------------------------------"
        # Wait until the server comes back (SSH reachable)
        until plink "$host" -batch -l "$REMOTE_USER" -pw "$REMOTE_PASS" "echo SSH is back" &>/dev/null; do
            echo "Waiting for $host to come back online..."
            sleep 5
        done
	echo "----------------------------------------"
	echo "----------------------------------------"
        echo "$host is back online."
	echo "----------------------------------------"
	echo "----------------------------------------"
    done
else
    echo "----------------------------------------"
    echo "Skipping Security Patching"
    echo "----------------------------------------"
fi
