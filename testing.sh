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

# Enable graphical login and change target from CLI to GUI
systemctl enable gdm3
systemctl set-default graphical.target


# Installing Other less important Programs
nala install tilix gh pulseaudio pavucontrol build-essential lua5.4 libxinerama-dev neofetch neovim blender freecad inkscape gparted scribus librecad nvidia-driver nvidia-opencl-icd cuda-toolkit-12-3 cuda-drivers gnome-tweaks htop nvtop -y 
flatpak install flathub com.visualstudio.code -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.synology.SynologyDrive -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install --user https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y


apt update
apt upgrade
apt autoremove

# Use nala
bash scripts/usenala
