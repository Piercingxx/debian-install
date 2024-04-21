#!/bin/bash

# https://github.com/Piercing666

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

# Import Keys and adds Repository
echo "Importing Keys and adding Repository"
wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | gpg --dearmor | dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg && echo 'deb [arch=amd64] https://pkg.surfacelinux.com/debian release main' \
	| tee /etc/apt/sources.list.d/linux-surface.list && apt update


#Installs the kernel
echo "Installing the kernel"
su -c "apt install linux-image-surface linux-headers-surface surface-ath10k-firmware-override"

#Installs and enables touch screen
echo "Enabling touch screen"
su -c "apt install iptsd libwacom-surface && systemctl enable iptsd"

#Installs and enables secure boot
echo "Enabling secure boot"
su -c "apt install linux-surface-secureboot-mok"

#Removes GRUB_TIMEOUT and shows the menu
echo "Removing GRUB_TIMEOUT"
su -c "cp /etc/default/grub /etc/default/grub.bak && sed -i 's/\<GRUB_TIMEOUT=0\>//g' /etc/default/grub && update-grub"

echo "Updating-grub"
update-grub


#battery optimization software
apt install tlp tlp-rdw smartmontools vainfo -y
#open tlp.conf in /etc and unhash DEVICES_TO_DISABLE_ON_STARTUP="bluetooth" 


echo "After reboot run vainfo and fix any errors"
sleep 5 && echo "Rebooting"

#reboot
