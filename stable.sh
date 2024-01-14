#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)


# Update packages list and update system
apt update
apt upgrade -y

# Install Essential Programs
apt install nala -y
nala install gnome-core network-manager-gnome wget dpkg unzip flatpak gnome-software-plugin-flatpak -y 

edit
edit
edit
edit
edit
edit
edit
