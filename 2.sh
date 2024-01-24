#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# powermode to performance
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor performance

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
nala install gh -y
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
flatpak install flathub com.leinardi.gwe -y

# install better discord
curl -O https://raw.githubusercontent.com/bb010g/betterdiscordctl/master/betterdiscordctl
chmod +x betterdiscordctl
sudo mv betterdiscordctl /usr/local/bin
sudo betterdiscordctl self-upgrade
betterdiscordctl --d-install flatpak install


apt update && upgrade -y
flatpak update -y
apt purge firefox -y

# do not install steam via flatpak
wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
gdebi steam.deb -y
#dependancies for steam
nala install libegl1:i386 libgbm1:i386 libgl1-mesa-dri:i386 libgl1:i386 nvidia-driver-libs:i386 steam-libs-amd64 steam-libs-i386
sudo apt install python3-mako -y
sudo apt install mangohud -y



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


# Copy extension files over
mkdir -p /home/$username/.local/share/gnome-shell/extensions
cp -R dotlocal/share/gnome-shell/extensions/* /home/$username/.local/share/gnome-shell/extensions/



apt update && upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a
apt install --fix-broken
apt autoremove 
apt update && upgrade -y
flatpak update



sudo reboot
