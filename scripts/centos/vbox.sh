#!/usr/bin/bash

set -x

sudo yum -y --enablerepo=epel install dkms
sudo yum -y install \
  bzip2 \
  kernel-devel \
  make \
  perl

# Uncomment this if you want to install Guest Additions with support for X
#sudo yum -y install xorg-x11-server-Xorg

# In CentOS 6 or earlier, dkms package provides SysV init script called
# dkms_autoinstaller that is enabled by default
if systemctl list-unit-files | grep -q dkms.service; then
  sudo systemctl start dkms
  sudo systemctl enable dkms
fi

VBOX_MNT=/mnt/isomount

sudo mkdir -p ${VBOX_MNT}
sudo mount -o loop,ro ~/VBoxGuestAdditions.iso ${VBOX_MNT}
sudo ${VBOX_MNT}/VBoxLinuxAdditions.run install
sudo umount ${VBOX_MNT}
sudo rm -rf ${VBOX_MNT}
