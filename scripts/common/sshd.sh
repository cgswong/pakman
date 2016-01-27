#!/usr/bin/env bash

set -ex

# UseDNS is mostly useless and disabling speeds up logins
sudo tee -a /etc/ssh/sshd_config <<EOF
UseDNS no
EOF
