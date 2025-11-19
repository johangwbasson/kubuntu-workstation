#!/bin/sh

set -eu

# Check for .vars.yml file
if [ ! -f .vars.yml ]; then
    echo "=== .vars.yml file not found!"
    if [ -f .vars-example.yml ]; then
        cp .vars-example.yml .vars.yml
        echo "=== Created .vars.yml from .vars-example.yml"
        echo "=== Please edit .vars.yml with your configuration and run this script again."
        exit 1
    else
        echo "=== ERROR: .vars-example.yml template file not found!"
        exit 1
    fi
fi

echo "=== setup.sh must be run as root."

echo "=== Updating packages and installing git & ansible"
sudo sh -c 'apt-get -y update && apt-get -y upgrade && apt-get -y install git ansible'

echo "=== Installing required Ansible collections"
ansible-galaxy collection install -r requirements.yml

echo "=== Running playbook"
ansible-playbook -K -i inventory workstation.yml

echo "=== Log out and in again, them run test.sh. No need to reboot."
echo "=== Note that the NordVPN network killswitch is OFF and requires activation"
