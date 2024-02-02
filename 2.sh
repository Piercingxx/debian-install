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
nala install gnome-calculator -y
nala install nautilus -y
nala install rename -y
nala install cups -y
nala install util-linux -y
nala install build-essential -y
nala install gdebi -y
nala install lua5.4 -y
nala install neofetch -y
nala install neovim -y
nala install gparted -y
nala install gnome-tweaks -y
nala install gnome-mpv -y
nala install btop -y
nala install curl -y
nala install unzip -y
nala install gh -y
nala install x11-xserver-utils -y
nala install dh-dkms -y
nala install devscripts -y
nala install papirus-icon-theme -y
nala install fonts-noto-color-emoji -y
nala install font-manager -y
apt update && upgrade -y
flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub net.scribus.Scribus -y
flatpak install flathub org.freecadweb.FreeCAD -y
flatpak install flathub org.blender.Blender -y
flatpak install flathub org.librecad.librecad -y
flatpak install flathub org.libreoffice.LibreOffice -y
flatpak install flathub com.google.Chrome -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.synology.SynologyDrive -y
flatpak install flathub com.dropbox.Client -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.obsproject.Studio -y
apt update && upgrade -y
flatpak update -y
apt purge firefox -y


# Add GIMP preferences 
rm -r /home/$username/.var/app/org.gimp.GIMP/config/GIMP/2.99
mkdir -p /home/$username/.var/app/org.gimp.GIMP/config/GIMP/2.99
cd dotconfig/Gimp
unzip My\ Active\ 2.99.zip -d /home/$username/.var/app/org.gimp.GIMP/config/GIMP/2.99
chown $username:$username /home/$username/.var/app/org.gimp.GIMP/config/GIMP/2.99/*
cd ..
cd ..


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


# Extensions - will need to be customized still
mkdir -p /home/$username/.local/share/gnome-shell/extensions
cp -R dotlocal/share/gnome-shell/extensions/* /home/$username/.local/share/gnome-shell/extensions/
chmod -R 777 /home/$username/.local/share/gnome-shell/extensions

# Removing zip files and stuff
rm ./FiraCode.zip ./Meslo.zip
rm -r dotconfig
rm -r dotlocal
re -r scripts


# Cursor 
wget -cO- https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.icons

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# icons
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'


apt update && upgrade -y
apt full-upgrade -y
apt install -f
dpkg --configure -a
apt install --fix-broken
apt autoremove 
apt update && upgrade -y
flatpak update
reboot
