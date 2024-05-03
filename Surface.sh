#!/bin/bash

# https://github.com/Piercing666

username=$(id -u -n 1000)

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<< "Network connectivity is required to continue."
    exit
fi

apt update && upgrade -y
wait

wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg
wait

echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" \
	| sudo tee /etc/apt/sources.list.d/linux-surface.list

apt update && upgrade -y
wait

echo "Installing the kernel"
apt install linux-image-surface linux-headers-surface surface-ath10k-firmware-override -y

echo "Enabling touch screen"
apt install iptsd libwacom-surface -y && systemctl enable iptsd

echo "Enabling secure boot"
apt install linux-surface-secureboot-mok -y

echo "Update-grub"
update-grub

echo "Enabling DTX Daemon"
systemctl enable surface-dtx-daemon.service
systemctl enable --"$username" surface-dtx-userd.service

#battery optimization software
apt install tlp tlp-rdw smartmontools vainfo -y
#open tlp.conf in /etc and unhash DEVICES_TO_DISABLE_ON_STARTUP="bluetooth" 

echo "After reboot run vainfo and fix any errors"
sleep 5 && echo "Rebooting"

# reboot
