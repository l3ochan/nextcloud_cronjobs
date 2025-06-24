#!/bin/bash

# List nextcloud users
user_list=$(php occ user:list)

# Extract usernames 
echo "$user_list" | while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*-[[:space:]]([^:]+): ]]; then
        username="${BASH_REMATCH[1]}"
        echo "[INFO]: Processing user : $username"
        php occ ews:harmonize "$username"
    fi
done
