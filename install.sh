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


# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds
cp -R dotconfig/* /home/$username/.config/
cp bg.jpg /home/$username/Pictures/backgrounds/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username


# Install nala
apt install nala -y

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.fonts


# Installing Essential Programs 
nala install gdm3 gnome-core network-manager-gnome nautilus flatpak gnome-software-plugin-flatpak unzip wget tilix -y


# Update repositories
sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf 
"deb https://deb.debian.org/debian/ buster main contrib non-free
deb https://security.debian.org/debian-security bookworm/updates main contrib non-free
deb https://deb.debian.org/debian/ stable-updates main contrib non-free
deb https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main
deb-src https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main
deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

wget https://developer.download.nvidia.com/compute/cuda/12.3.1/local_installers/cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb
dpkg -i cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb\
cp /var/cuda-repo-debian12-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
add-apt-repository contrib

apt -y dist-upgrade


# Installing Other less important Programs
nala install pulseaudio pavucontrol build-essential lua5.4 libxinerama-dev neofetch neovim blender freecad inkscape gparted scribus steam-launcher librecad nvidia-driver nvidia-opencl-icd cuda-toolkit-12-3 cuda-drivers nvidia-kernel-open-dkms gnome-tweaks -y
flatpak install flathub com.visualstudio.code
flatpak install flathub md.obsidian.Obsidian
flatpak install flathub com.synology.SynologyDrive
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.obsproject.Studio
flatpak install flathub com.mattjakeman.ExtensionManager
flatpak install --user https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref
flatpak run org.gimp.GIMP//beta
# the only app that I use and can not install via script is Davinci Resolve Studio


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



# Enable graphical login and change target from CLI to GUI
systemctl enable gdm3
systemctl set-default graphical.target




# Bash Menu Microsoft Surface Stuffs - the password is surface
items=(1 "Yes"
       2 "No")

while choice=$(dialog --title "$TITLE" \
                 --menu "Is This A Microsoft Surface Device?" 10 40 3 "${items[@]}" \
                 2>&1 >/dev/tty)
    do
    case $choice in
        1) ;; wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
         | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg
echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" \
	| sudo tee /etc/apt/sources.list.d/linux-surface.list
apt update
apt install linux-image-surface linux-headers-surface libwacom-surface iptsd
apt install linux-surface-secureboot-mok
update-grub
        2) ;; clear
    esac
done
clear # clear after user pressed Cancel



# Use nala
bash scripts/usenala
