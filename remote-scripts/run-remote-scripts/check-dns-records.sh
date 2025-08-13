#!/bin/bash

IP1="165.143.131.218"
IP2="165.143.130.221"
FILE="/etc/resolv.conf"

found1=$(grep -c "$IP1" "$FILE")
found2=$(grep -c "$IP2" "$FILE")

if [[ $found1 -gt 0 && $found2 -gt 0 ]]; then
  echo "Error: Both $IP1 (CNTRRA20-DC01) and $IP2 (CNTRRA20-DC03) are present in $FILE. Only one or none is allowed."
  exit 1
else
  echo "OK: Either one or none of the IPs is present in $FILE."
  exit 0
fi
