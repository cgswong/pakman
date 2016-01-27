#!/usr/bin/env bash

set -ex

# Install dependencies
sudo apt-get -y install \
  dkms \
  make

# Uncomment this if you want to install Guest Additions with support for X
#sudo apt-get -y install xserver-xorg

VBOX_MNT=/mnt/isomount

sudo mkdir -p ${VBOX_MNT}
sudo mount -t iso9660 -o loop,ro ~/VBoxGuestAdditions.iso ${VBOX_MNT}
sudo ${VBOX_MNT}/VBoxLinuxAdditions.run install
sudo umount ${VBOX_MNT}
sudo rm -rf ${VBOX_MNT}

# mountpoint for vagrant
sudo mkdir -p /vagrant
