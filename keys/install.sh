#!/bin/bash
set -eu

if [ -e ~/.ssh/id_henrist ]; then
    echo "Keys are already set up"
    exit
fi

# Get my keys
echo "Pulling ssh-key from hsw.no"
scp henrik@hsw.no:.ssh/id_henrist* ~/.ssh/

# Add public key
if ! [ -e ~/.ssh/authorized_keys ] || ! grep -q "$(awk '{ print $2 }' ~/.ssh/id_henrist.pub)" ~/.ssh/authorized_keys; then
    cat ~/.ssh/id_henrist.pub >>~/.ssh/authorized_keys
fi

# Set some permissions
chmod 600 ~/.ssh/id_henrist
chmod 644 ~/.ssh/id_henrist.pub
