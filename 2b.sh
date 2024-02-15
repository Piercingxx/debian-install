#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Install flatpak
nala install flatpak gnome-software-plugin-flatpak -y

flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update -y




#Installing Priority Programs to setup while this script runs
nala install gnome-tweaks -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
nala install nautilus -y
flatpak install flathub com.google.Chrome -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.synology.SynologyDrive -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.dropbox.Client -y
nala install papirus-icon-theme -y
nala install fonts-noto-color-emoji -y
nala install font-manager -y
nala install build-essential -y
nala install unzip -y
nala install linux-headers-generic -y


# Install vscode - no flatpak!
nala install lua5.4 -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt install apt-transport-https
apt update
apt install code -y

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
rm -r dotlocal
rm -r scripts

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


# Installing other less important but still important progs
flatpak install flathub org.libreoffice.LibreOffice -y
nala install gnome-calculator -y
nala install rename -y
nala install cups -y
nala install util-linux -y
nala install gdebi -y
nala install neofetch -y
nala install gparted -y
nala install gnome-mpv -y
nala install btop -y
nala install curl -y
nala install gh -y
nala install x11-xserver-utils -y
nala install dh-dkms -y
nala install devscripts -y
apt update && upgrade -y
flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
flatpak install flathub org.gnome.SimpleScan -y
flatpak install flathub net.scribus.Scribus -y
flatpak install flathub org.blender.Blender -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub com.flashforge.FlashPrint -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub com.usebottles.bottles -y
apt update && upgrade -y
flatpak update -y
apt purge firefox -y
apt purge firefox-esr -y


# dependancy for DaVinci Resolve Studio - have to install manually later, download from website
nala install libfuse2 libglu1-mesa libxcb-composite0 libxcb-cursor0 libxcb-damage0 ocl-icd-libopencl1 libssl-dev ocl-icd-opencl-dev libpango-1.0-0-y
cp /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0 /opt/resolve/libs
cd /opt/resolve/libs
sudo mkdir /opt/resolve/libs/_disabled
sudo mv libgio* libglib* libgmodule* libgobject* _disabled
cd /


apt update && upgrade -y
apt full-upgrade -y
apt install -f
dpkg --configure -a
apt install --fix-broken
apt autoremove 
apt update && upgrade -y
flatpak update
reboot
