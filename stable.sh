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
sudo rm /lib/systemd/system/gdm3.service && sudo touch /lib/systemd/system/gdm3.service && sudo chmod +rwx /lib/systemd/system/gdm3.service && sudo printf "[Unit]
Description=GNOME Display Manager

# replaces the getty
Conflicts=getty@tty1.service
After=getty@tty1.service

# replaces plymouth-quit since it quits plymouth on its own
Conflicts=plymouth-quit.service
After=plymouth-quit.service

# Needs all the dependencies of the services it's replacing
# pulled from getty@.service and plymouth-quit.service
# (except for plymouth-quit-wait.service since it waits until
# plymouth is quit, which we do)
After=rc-local.service plymouth-start.service systemd-user-sessions.service

# GDM takes responsibility for stopping plymouth, so if it fails
# for any reason, make sure plymouth still stops
OnFailure=plymouth-quit.service

[Service]
ExecStartPre=/usr/share/gdm/generate-config
ExecStart=/usr/sbin/gdm3
KillMode=mixed
Restart=always
RestartSec=1s
IgnoreSIGPIPE=no
BusName=org.gnome.DisplayManager
EnvironmentFile=-/etc/default/locale
ExecReload=/usr/share/gdm/generate-config
ExecReload=/bin/kill -SIGHUP $MAINPID
KeyringMode=shared

[Install]
WantedBy=multi-user.target" | sudo tee -a /lib/systemd/system/gdm3.service

systemctl enable gdm3
systemctl set-default graphical.target



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


apt update
apt upgrade -y
apt full-upgrade -y

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
# the only app that I use and can not install via script is Davinci Resolve Studio

# Making dir
cd $builddir
mkdir -p /home/$username/.fonts

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

apt update
apt upgrade
apt autoremove

# Use nala
bash scripts/usenala





# To switch from legacy to open nvidia drivers:
# sudo apt-get --purge remove nvidia-kernel-dkms
# sudo apt-get install --verbose-versions nvidia-kernel-open-dkms
# sudo apt-get install --verbose-versions cuda-drivers-XXX

# To switch from open to legacy nvidia drivers:
# sudo apt-get remove --purge nvidia-kernel-open-dkms
# sudo apt-get install --verbose-versions cuda-drivers-XXX
