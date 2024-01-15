#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)



# Installing other less important but still important Programs and drivers
nala install tilix -y
nala install build-essential -y
nala install lua5.4 -y
nala install neofetch -y
nala install neovim -y
nala install gparted -y
nala install gnome-tweaks -y
nala install htop -y
apt update && upgrade -y
flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
flatpak install flathub net.scribus.Scribus -y
flatpak install flathub org.freecadweb.FreeCAD -y
flatpak install flathub org.blender.Blender -y
flatpak install flathub org.librecad.librecad -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.synology.SynologyDrive -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
nala install nvtop -y 


apt update && upgrade -y
flatpak update -y



# Installing fonts
cd $builddir 
nala install fonts-font-awesome fonts-noto-color-emoji -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*


# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip





sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://deb.debian.org/debian/ testing main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security testing-security/updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ testing-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ testing contrib main contrib non-free non-free-firmware 
deb-src https://deb.debian.org/debian/ testing-updates main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list



apt update && upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a
apt install --fix-broken
apt update && upgrade -y
flatpak update



sudo reboot
