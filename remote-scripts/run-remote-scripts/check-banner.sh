#!/bin/bash

# Check if Banner is enabled in sshd_config
banner_config=$(grep -Ei '^\s*Banner\s+' /etc/ssh/sshd_config)

if [[ -z "$banner_config" ]]; then
    echo "Banner setting not found in /etc/ssh/sshd_config."
    exit 1
fi

# Extract the path to the banner file
banner_file=$(echo "$banner_config" | awk '{print $2}')

if [[ "$banner_file" == "none" ]]; then
    echo "SSH banner is disabled (Banner set to 'none')."
    exit 0
fi

echo "SSH banner is configured: $banner_file"

# Check if the banner file exists and is readable
if [[ -f "$banner_file" && -r "$banner_file" ]]; then
    echo "Banner file exists and is readable:"
    ls -ltr "$banner_file"
else
    echo "Banner file $banner_file does not exist or is not readable."
fi

