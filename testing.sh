#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)


sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://deb.debian.org/debian/ testing main non-free-firmware
deb http://security.debian.org/debian-security testing-security/updates main non-free-firmware
deb https://deb.debian.org/debian/ testing-updates main non-free-firmware
deb-src https://deb.debian.org/debian/ testing main non-free-firmware 
deb-src https://deb.debian.org/debian/ testing-updates main non-free-firmware



apt update && upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a
apt install --fix-broken
apt update && upgrade -y
flatpak update
