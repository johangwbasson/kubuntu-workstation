#!/bin/sh

set -eu

ansible-playbook -K -i inventory workstation.yml
