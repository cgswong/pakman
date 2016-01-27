#!/usr/bin/env bash

set -ex

sudo apt-get -y update
sudo apt-get -y install \
  ansible \
  audispd-plugins \
  auditd \
  bridge-utils \
  bundler \
  cgroup-bin \
  git \
  jq \
  libcurl3 \
  libffi-dev \
  libssl-dev \
  ruby \
  unzip \
  wget \
  zsh

sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
sudo pip install --upgrade pip
