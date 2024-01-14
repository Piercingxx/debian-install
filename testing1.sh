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

# Making dir
cd $builddir
mkdir -p /home/$username/.fonts
mkdir -p /var/lib/usbmux/.config


# Install Essential Programs part 1of2
apt install nala 
nala install wget flatpak gnome-software-plugin-flatpak -y 



# Add additional repositories
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-repo-debian12-12-3-local_12.3.2-545.23.08-1_amd64.deb
dpkg -i cuda-repo-debian12-12-3-local_12.3.2-545.23.08-1_amd64.deb
cp /var/cuda-repo-debian12-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/


# Esure all repositories are up to date
sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://deb.debian.org/debian/ buster main contrib non-free
deb http://security.debian.org/debian-security stable-security/updates main contrib non-free
deb https://deb.debian.org/debian/ stable-updates main contrib non-free
deb https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main
deb-src https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main 
deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list


nala update && upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a
apt update
apt upgrade
nala install --fix-broken
flatpak update

reboot
