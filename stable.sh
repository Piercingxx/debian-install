#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)


# Update packages list and update system
apt update
apt upgrade -y

# Install software to get started
apt install nala wget unzip flatpak gnome-software-plugin-flatpak dpkg -y

# Making dir
cd $builddir
mkdir -p /home/$username/.fonts



# Update repositories
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
wget https://developer.download.nvidia.com/compute/cuda/12.3.1/local_installers/cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb
dpkg -i cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb\
cp /var/cuda-repo-debian12-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://deb.debian.org/debian/ buster main contrib non-free
deb http://security.debian.org/debian-security stable-security/updates main contrib non-free
deb https://deb.debian.org/debian/ stable-updates main contrib non-free
deb https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main
deb-src https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main 
deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list


apt update
apt upgrade -y
apt full-upgrade -y
    

add-apt-repository contrib
apt -y dist-upgrade

# Installing Essential Programs 
nala install gnome-core network-manager-gnome gdm3 -y 


# Installing Other less important Programs
nala install nautilus tilix gh pulseaudio pavucontrol build-essential lua5.4 libxinerama-dev neofetch neovim blender freecad inkscape gparted scribus librecad nvidia-driver nvidia-opencl-icd cuda-toolkit-12-3 cuda-drivers nvidia-kernel-open-dkms gnome-tweaks htop nvtop-y
flatpak install flathub com.visualstudio.code -y --assume-yes
flatpak install flathub md.obsidian.Obsidian -y --assume-yes
flatpak install flathub com.synology.SynologyDrive -y --assume-yes
flatpak install flathub com.valvesoftware.Steam -y --assume-yes
flatpak install flathub com.discordapp.Discord -y --assume-yes
flatpak install flathub com.obsproject.Studio -y --assume-yes
flatpak install flathub com.mattjakeman.ExtensionManager -y --assume-yes
flatpak install --user https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y --assume-yes
flatpak run org.gimp.GIMP//beta -y --assume-yes
# the only app that I use and can not install via script is Davinci Resolve Studio


# Enable graphical login and change target from CLI to GUI
systemctl enable gdm3
systemctl set-default graphical.target
    
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


# Gnome-extensions 
wget https://gitlab.com/AndrewZaech/aztaskbar/-/archive/main/aztaskbar-main.zip
gnome-extensions install aztaskbar-main.zip

wget https://codeload.github.com/ubuntu/gnome-shell-extension-appindicator/zip/refs/heads/master
gnome-extensions install gnome-shell-extension-appindicator

wget https://codeload.github.com/velitasali/gnome-shell-extension-awesome-tiles/zip/refs/heads/main
gnome-extensions install gnome-shell-extension-awesome-tiles

https://codeload.github.com/aunetx/blur-my-shell/zip/refs/heads/master
gnome-extensions install blur-my-shell

wget https://codeload.github.com/Schneegans/Burn-My-Windows/zip/refs/heads/main
gnome-extensions install Burn-My-Windows

wget https://codeload.github.com/corecoding/Vitals/zip/refs/heads/main
gnome-extensions install Vitals


# Use nala
bash scripts/usenala
