#!/bin/sh

export RELAY_IP=`terraform output -raw relay-public-ip`
export PROXY_INTERNAL_IP=`terraform output -raw socks-private-ip`

ssh-keygen -f "/home/user/.ssh/known_hosts" -R "$RELAY_IP"

while true; do
    ssh -i ./i0001_ssh_key ubuntu@$RELAY_IP -L 1080:$PROXY_INTERNAL_IP:1080 -N
done
