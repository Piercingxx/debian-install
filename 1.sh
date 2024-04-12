#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

echo "Starting Script 1.sh"
sleep 2

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<< "Network connectivity is required to continue."
    exit
fi

apt install nala -y

# Enables non-free repositories and adds them to the sources list.
sudo rm /etc/apt/sources.list
sudo touch /etc/apt/sources.list 
sudo chmod +rwx /etc/apt/sources.list
sudo printf "deb https://deb.debian.org/debian/ stable main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security stable-security/updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list

sudo add-apt-repository ppa:graphics-drivers/ppa -y

# Update packages list and update system
apt update 
apt upgrade -y
wait

# Making dir
cd "$builddir" || exit
mkdir -p /home/"$username"/.fonts
mkdir -p /var/lib/usbmux/.config


echo "Install Essentials"
sleep 2
apt install wget gpg flatpak gnome-software-plugin-flatpak -y
flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
apt update && upgrade -y
wait
apt full-upgrade -y
wait
sudo apt install -f
wait
flatpak update
wait
nala install gnome-shell -y
nala install kitty -y
nala install gnome-terminal -y
nala install gnome-text-editor -y
nala install dconf* -y
nala install zip unzip gzip tar make curl -y
wait

echo "Changing Graphical Login"
sleep 2
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



echo "Hello Handsome"
sleep 2
# Edit Graphical Login Settings
sudo rm /etc/gdm3/greeter.dconf-defaults && sudo touch /etc/gdm3/greeter.dconf-defaults && sudo chmod +rwx /etc/gdm3/greeter.dconf-defaults && sudo printf "# These are the options for the greeter session that can be set 
# through GSettings. Any GSettings setting that is used by the 
# greeter session can be set here.

# Note that you must configure the path used by dconf to store the 
# configuration, not the GSettings path.


# Theming options
# ===============
#  - Change the GTK+ theme
[org/gnome/desktop/interface]
# gtk-theme='Adwaita'
#  - Use another background
[org/gnome/desktop/background]
# picture-uri='file:///usr/share/themes/Adwaita/backgrounds/stripes.jpg'
# picture-options='zoom'
#  - Or no background at all
[org/gnome/desktop/background]
# picture-options='none'
# primary-color='#000000'

# Login manager options
# =====================
[org/gnome/login-screen]
# logo='/usr/share/images/vendor-logos/logo-text-version-64.png'

# - Disable user list
# disable-user-list=true
# - Disable restart buttons
# disable-restart-buttons=true
# - Show a login welcome message
banner-message-enable=true
banner-message-text='Hello Handsome'

# Automatic suspend
# =================
[org/gnome/settings-daemon/plugins/power]
# - Time inactive in seconds before suspending with AC power
#   1200=20 minutes, 0=never
sleep-inactive-ac-timeout=0
# - What to do after sleep-inactive-ac-timeout
#   'blank', 'suspend', 'shutdown', 'hibernate', 'interactive' or 'nothing'
sleep-inactive-ac-type='suspend'
# - As above but when on battery
sleep-inactive-battery-timeout=1200
sleep-inactive-battery-type='suspend'
#" | sudo tee -a /etc/gdm3/greeter.dconf-defaults


# Finalizing graphical login
systemctl enable gdm
systemctl enable gdm3 --now


# Use nala
bash scripts/usenala


# Beautiful bash modified Chris Titus' bash
unzip mybash.zip
chmod -R 777 mybash
cd mybash || exit
./setup.sh
wait
cd "$builddir" || exit
rm -rf mybash


apt update && upgrade -y
wait
flatpak update -y
wait
apt full-upgrade -y
wait
apt install -f
dpkg --configure -a
echo "After reboot run 2.sh"
sleep 3 && echo "Rebooting"
reboot
