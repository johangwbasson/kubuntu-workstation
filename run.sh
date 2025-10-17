#!/bin/sh

set -eu

ansible-playbook -i inventory workstation.yml
