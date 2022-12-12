#!/bin/sh

export SECRET_KEY_FILE=$1
export RELAY_IP=$2
export PROXY_INTERNAL_IP=$3

ssh-keygen -f "/home/user/.ssh/known_hosts" -R "$RELAY_IP"

while true; do
    ssh -o "StrictHostKeyChecking=no" -i $SECRET_KEY_FILE ubuntu@$RELAY_IP -L 1080:$PROXY_INTERNAL_IP:1080 -N
done
