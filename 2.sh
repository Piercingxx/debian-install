#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

echo "Starting Script 2.sh"
sleep 2

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
  awk '{print}' <<<"Network connectivity is required to continue."
  exit
fi

echo "Updating Repositiories"
sleep 2
add-apt-repository universe -y
apt update && upgrade -y
wait

#Installing Priority Programs to setup while this script runs
echo "Installing Programs and Drivers"
sleep 2
nala install gnome-tweaks -y
nala install nautilus -y
nala install papirus-icon-theme -y
nala install fonts-noto-color-emoji -y
nala install font-manager -y
nala install build-essential -y
nala install unzip -y
nala install linux-headers-generic -y
nala install seahorse -y
nala install gnome-calculator -y
nala install rename -y
nala install cups -y
nala install util-linux -y
nala install xdg-utils -y
nala install dbus-x11 -y
nala install gdebi -y
nala install neofetch -y
nala install mpv -y
nala install gparted -y
nala install btop -y
nala install curl -y
nala install gh -y
nals install fuse -y
nala install libfuse2 -y
nala install x11-xserver-utils -y
nala install dh-dkms -y
nala install devscripts -y
nala install lua5.4 -y
sleep 2
flatpak install flathub com.google.Chrome -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.dropbox.Client -y
flatpak install flathub org.libreoffice.LibreOffice -y
flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
flatpak install flathub org.gnome.SimpleScan -y
flatpak install flathub org.blender.Blender -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub net.scribus.Scribus -y
flatpak install flathub org.gnome.gThumb -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
# flatpak install flathub com.flashforge.FlashPrint -y# flatpak install flathub com.obsproject.Studio -y

# VSCode
wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/1e790d77f81672c49be070e04474901747115651/code_1.87.1-1709685762_amd64.deb
wait
dpkg -i code_1.87.1-1709685762_amd64.deb
wait
rm code_1.87.1-1709685762_amd64.deb

# Synology Drive
wget "https://global.download.synology.com/download/Utility/SynologyDriveClient/3.4.0-15724/Ubuntu/Installer/synology-drive-client-15724.x86_64.deb"
wait
sudo dpkg -i synology-drive-client-15724.x86_64.deb
wait
rm synology-drive-client-15724.x86_64.deb

# steam
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
wait
sudo dpkg -i steam.deb
wait
rm steam.deb
# i386 is needed for steam to launch
sudo dpkg --add-architecture i386


# Things to download and install only if you need them
# VPN
wget https://installers.privateinternetaccess.com/download/pia-linux-3.5.5-08091.run
wait
#FlashForge
wget https://en.fss.flashforge.com/10000/software/e02d016281d06012ea71a671d1e1fdb7.deb
wait

apt update && upgrade -y
wait

echo "Installing Fonts"
sleep 2
# Installing fonts
cd "$builddir" || exit

nala install fonts-font-awesome fonts-noto-color-emoji -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/"$username"/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/"$username"/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/"$username"/.fonts/
chown "$username":"$username" /home/"$username"/.fonts/*
nala install ttf-mscorefonts-installer -y

# Reloading Font
fc-cache -vf
wait

echo "Installing Cursors & Icons"
sleep 2
# Cursor
wget -cO- https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.icons

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors || exit
./install.sh
cd "$builddir" || exit

# Beautiful bash by Chris Titus
git clone https://github.com/ChrisTitusTech/mybash
cd mybash || exit
bash setup.sh
cd "$builddir" || exit

# Extensions - will need to be customized still
echo "Gnome Extensions"
sleep 2
mkdir -p /home/"$username"/.local/share/gnome-shell/extensions
nala install gnome-shell-extension-appindicator -y
nala install gnome-shell-extension-gsconnect -y

# Awesome Tiles
wget https://codeload.github.com/velitasali/gnome-shell-extension-awesome-tiles/zip/refs/heads/main
unzip gnome-shell-extension-awesome-tiles-main.zip
rm gnome-shell-extension-awesome-tiles-main.zip
cp -R gnome-shell-extension-awesome-tiles-main /home/"$username"/.local/share/gnome-shell/extensions/

# Blur my Shell
wget https://codeload.github.com/aunetx/blur-my-shell/zip/refs/heads/master
unzip blur-my-shell-master.zip
rm blur-my-shell-master.zip
cp -R blur-my-shell-master /home/"$username"/.local/share/gnome-shell/extensions/

# App Icons Taskbar
wget https://gitlab.com/AndrewZaech/aztaskbar/-/archive/main/aztaskbar-main.zip
unzip aztaskbar-main.zip
rm aztaskbar-main.zip
cp -R aztaskbar-main /home/"$username"/.local/share/gnome-shell/extensions/

chmod -R 777 /home/"$username"/.local/share/gnome-shell/extensions

# Kitty Terminal Modifications
cp -R /dotconf/kitty /home/"$username"/.config/kitty/

# Removing zip files and stuff
rm ./FiraCode.zip ./Meslo.zip
rm -r /dotconf
rm -r scripts
rm -rf mybash
rm -rf Nordzy-cursors

# Used in fstab
mkdir -p /media/Working-Storage
mkdir -p /media/Archived-Storage

echo "Installing Dependencies for DaVinci Resolve."
sleep 2
nala install libglu1-mesa -y
nala install libgdk-pixbuf2.0-0 -y
nala install libxcb-composite0 -y
nala install libxcb-cursor0 -y
nala install libxcb-damage0 -y
nala install ocl-icd-libopencl1 -y
nala install libssl-dev -y
nala install ocl-icd-opencl-dev -y
nala install libpango-1.0-0 -y
nala install libxml2-utils -y
nala install podman-toolbox -y
wait

apt update && upgrade -y
wait
apt full-upgrade -y
wait
apt install -f
wait
dpkg --configure -a
apt install --fix-broken
wait
apt autoremove -y
apt update && upgrade -y
wait
flatpak update

# Preferences
echo "Updating Customization Preferences"
sleep 2
sudo -u "$username" gsettings set org.gnome.desktop.interface clock-format 24h && echo "Clock Format: 24h"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true && echo "Numlock State: True"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface color-scheme prefer-dark && echo "Color Scheme: Dark"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark && echo "GTK Theme: Adwaita-dark"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors' && echo "Cursor Theme: Nordzy"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' && echo "Icon Theme: Papirus-Dark"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface enable-animations false && echo "Enable Animations: False"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface clock-show-weekday true && echo "Clock Show Weekday: True"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' && echo "Sleep Inactive AC: Nothing"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.session idle-delay 0 && echo "Lock Screen Idle: 20"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface show-battery-percentage true && echo "Show Battery Percentage: True"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false && echo "Ambient Enabled: False"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.power idle-dim false && echo "Idle Dim: False"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true && echo "Night Light Enabled: True"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false && echo "Night Light Schedule Automatic: False"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20 && echo "Night Light Schedule From: 20"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 04 && echo "Night Light Schedule To: 04"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 2500 && echo "Night Light Temperature: 2500"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.interface enable-hot-corners false && echo "Enable Hot Corners: False"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.background picture-options 'spanned' && echo "Background Options: Spanned"
sleep 1
sudo -u "$username" gsettings set org.gnome.shell favorite-apps "['com.google.Chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.libreoffice.LibreOffice.writer.desktop', 'org.gnome.Calculator.desktop', 'md.obsidian.Obsidian.desktop', 'com.visualstudio.code.desktop', 'code.desktop', 'com.discordapp.Discord.desktop']" && echo "Favorite Apps: Chrome, Nautilus, LibreOffice, Calculator, Obsidian, Visual Studio Code, Discord"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.input-sources xkb-options "['caps:backspace']" && echo "Caps Lock: Backspace"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']" && echo "Custom Keybindings: None"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "kitty" && echo "Kitty: Name"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "kitty" && echo "Kitty: Command"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Primary><Alt>T" && echo "Kitty: Binding"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true && echo "Tap to Click: True"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true && echo "Natural Scroll: True"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled true && echo "Edge Scrolling: True"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled false && echo "Two Finger Scrolling: False"
sleep 1
sudo -u "$username" gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas' && echo "Click Method: Areas"
sleep 1
sudo -u "$username" gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive' && echo "Power Button Action: Interactive"
sleep 1

# Enable Gnome Extensions
sudo -u "$username" gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com && echo "App Indicator Support: Enabled"
sleep 1
sudo -u "$username" gnome-extensions enable aztaskbar@aztaskbar.gitlab.com && echo "AzTaskbar: Enabled"
sleep 1
sudo -u "$username" gnome-extensions enable awesome-tiles@velitasali.com && echo "Awesome Tiles: Enabled"
sleep 1
sudo -u "$username" gnome-extensions enable blur-my-shell@aunetx && echo "Blur My Shell: Enabled"
sleep 1
sudo -u "$username" gnome-extensions enable gsconnect@andyholmes.github.io && echo "GSConnect: Enabled"
sleep 1

# Modify Gnome Extensions
dconf write /org/gnome/shell/extensions/awesome-tiles/gap-size-increments "1" && echo "Awesome Tiles Gap Size Increments: 1"
sleep 1
dconf write /org/gnome/shell/extensions/aztaskbar/favorites "false" && echo "AzTaskbar Favorites: False"
sleep 1
dconf write /org/gnome/shell/extensions/aztaskbar/main-panel-height "33" && echo "AzTaskbar Main Panel Height: 33"
sleep 1
dconf write /org/gnome/shell/extensions/aztaskbar/show-panel-activities-button "false" && echo "AzTaskbar Show Panel Activities Button: False"
sleep 1
dconf write /org/gnome/shell/extensions/aztaskbar/icon-size "23" && echo "AzTaskbar Icon Size: 23"
sleep 1
dconf write /org/gnome/shell/extensions/blur-my-shell/brightness "1.0" && echo "Blur My Shell Brightness: 1.0"
sleep 1

echo "After rebooting, install Steam then run Script 3.sh for Nvidia drivers."
echo "Skip 3.sh if you are not using Nvidia hardware."
sleep 5
sudo reboot

# If this is your first time using VSCode then create an account and set it up with these extensions.
# This is a great place to start. This is setup for Lua and Bash, feel free to customize.
# Copy these to a new .sh and run it in terminal - Do not run as sudo.
# code --install-extension DaltonMenezes.aura-theme
# code --install-extension rogalmic.bash-debug
# code --install-extension mads-hartmann.bash-ide-vscode
# code --install-extension CoenraadS.bracket-pair-colorizer
# code --install-extension streetsidesoftware.code-spell-checker
# code --install-extension sourcegraph.cody-ai
# code --install-extension kamikillerto.vscode-colorize
# code --install-extension appulate.filewatcher
# code --install-extension GitHub.vscode-pull-request-github
# code --install-extension eamodio.gitlens
# code --install-extension oderwat.indent-rainbow
# code --install-extension SirTori.indenticator
# code --install-extension ritwickdey.LiveServer
# code --install-extension sumneko.lua
# code --install-extension actboy168.lua-debug
# code --install-extension openra.vscode-openra-lua
# code --install-extension johnpapa.vscode-peacock
# code --install-extension jeanp413.open-remote-ssh
# code --install-extension timonwong.shellcheck
# code --install-extension JohnnyMorganz.stylua
# code --install-extension foxundermoon.shell-format
