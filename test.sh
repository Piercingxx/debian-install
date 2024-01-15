#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)


sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://deb.debian.org/debian/ stable main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security stable-security/updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list




# Update packages list and update system
apt update && upgrade -y

# Making dir
cd $builddir
mkdir -p /home/$username/.fonts
mkdir -p /var/lib/usbmux/.config


# Install Essentials
apt install nala wget flatpak gnome-software-plugin-flatpak -y

flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
apt update && upgrade -y
apt full-upgrade -y
sudo apt install -f
flatpak update


nala install gnome-core -y


# Enable graphical login and change target from CLI to GUI

# First admend the .gdm3 to add Intall section
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



# And then the .gdm to add Intall section
sudo rm /lib/systemd/system/gdm.service && sudo touch /lib/systemd/system/gdm.service && sudo chmod +rwx /lib/systemd/system/gdm.service && sudo printf "[Unit]
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
WantedBy=multi-user.target" | sudo tee -a /lib/systemd/system/gdm.service

# Finalizing graphical login
systemctl enable gdm
systemctl enable gdm3 --now
sudo systemctl enable gdm3 --now

nala update && upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a


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
flatpak install flathub com.dropbox.Client -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.synology.SynologyDrive -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
nala install nvtop -y 
apt update && upgrade -y
nala install gh -y
nala install cuda-toolkit-12-3 cuda-drivers -y
apt update && upgrade -y
nala install -y nvidia-kernel-open-dkms -y
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









# Video card drivers
# nala install linux-headers-amd64 nvidia-driver firmware-misc-nonfree nvidia-installer-cleanup -y








# Use nala
bash scripts/usenala

apt update && upgrade -y
flatpak update -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a



sudo reboot
