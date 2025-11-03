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

ansible-playbook -K -i inventory workstation.yml
