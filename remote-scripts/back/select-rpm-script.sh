#!/bin/bash

REMOTE_PATH="/c/Users/makwetjat/remote-scripts"

cd  $REMOTE_PATH/rpms
files=( *.rpm )

PS3='Select remote script to run or 0 to exit: '
select file in "${files[@]}"; do
    if [[ $REPLY == "0" ]]; then
        echo 'Bye!' >&2
        exit
    elif [[ -z $file ]]; then
        echo 'Invalid choice, try again' >&2
    else
        CMD_RPM="$file"  # Assign the selected script
        break
    fi
done

echo "Selected package: $CMD_RPM"

echo $CMD_RPM

