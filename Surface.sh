#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

#disable automatic screen brightness
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

apt update && upgrade -y

wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg

echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" \
	| sudo tee /etc/apt/sources.list.d/linux-surface.list
        
apt update

apt install linux-image-surface linux-headers-surface libwacom-surface iptsd -y

apt install linux-surface-secureboot-mok -y

update-grub

#battery optimization software
nala install tlp tlp-rdw smartmontools vainfo -y
#open tlp.conf in /etc and unhash DEVICES_TO_DISABLE_ON_STARTUP="bluetooth" 


#after reboot run vainfo and fix any errors if any

reboot
