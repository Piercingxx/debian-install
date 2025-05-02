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

sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb http://deb.debian.org/debian/ testing main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security testing-security main non-free-firmware
deb http://deb.debian.org/debian/ testing-updates main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list



apt update && upgrade -y
wait
apt full-upgrade -y
wait
sudo apt install -f
wait
sudo dpkg --configure -a
wait
apt install --fix-broken
wait
apt update && upgrade -y
wait
flatpak update
wait
apt auto-remove -y
wait

reboot
