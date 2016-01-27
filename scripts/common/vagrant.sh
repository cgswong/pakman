#!/usr/bin/sh

set -ex

# Setup environment
SSH_HOME="~/.ssh"

date | sudo tee /etc/vagrant_box_build_time

mkdir -p ${SSH_HOME}
curl -fsSL --output ${SSH_HOME}/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 700 ${SSH_HOME}/
chmod 600 ${SSH_HOME}/authorized_keys
