#!/bin/sh

sudo chown user.user /var/run/docker.sock

DOCKERHOSTIP=`host host.docker.internal | sed -E -n 's/.* has address (([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)).*/\2.\3.\4.\5/p' | awk NF`
CERTHOSTNAME='sample-cluster-control-plane'

# Everything after this point runs just once, while everything above runs
# -for every login shell.
if grep -q $CERTHOSTNAME /etc/hosts; then
    exit 0
fi

# Map from dockers host.docker.internal IP to the kubernetes control-plane hostname
echo "$DOCKERHOSTIP $CERTHOSTNAME" | sudo tee -a /etc/hosts

# Persist extensions
mv /home/user/.vscode-server/extensions /tmp/.vscode-server-extensions
ln -s /workspaces/seed/.devcontainer/vscode-server-extensions-persist \
    /home/user/.vscode-server/extensions

cp -a /home/user/.kube-host /home/user/.kube
sed -i 's^\(.*server: https://\)\([^:]\+\):\(.*\)$^\1'$CERTHOSTNAME':\3^g' \
    /home/user/.kube/config
