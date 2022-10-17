#!/bin/bash -eux

sudo apt-get update
sudo add-apt-repository --yes ppa:ansible/ansible
sudo apt-get --assume-yes update
sudo apt-get --assume-yes --with-new-pkgs upgrade
sudo apt-get --assume-yes --no-install-recommends install ansible

cd /var/tmp/ansible || exit 1
sh provision.sh
