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
    awk '{print}' <<< "Network connectivity is required to continue."
    exit
fi


echo "Updating Repositiories"
sleep 2
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
nala install gdebi -y
nala install neofetch -y
nala install gparted -y
nala install btop -y
nala install curl -y
nala install gh -y
nala install libfuse2 -y
nala install x11-xserver-utils -y
nala install dh-dkms -y
nala install devscripts -y
nala install lua5.4 -y
wait
flatpak install flathub com.google.Chrome -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.dropbox.Client -y
flatpak install flathub org.libreoffice.LibreOffice -y
flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
flatpak install flathub org.gnome.SimpleScan -y
flatpak install flathub org.videolan.VLC -y
flatpak install flathub org.blender.Blender -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub net.scribus.Scribus -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub org.qbittorrent.qBittorrent -y
# flatpak install flathub com.mattjakeman.ExtensionManager -y
# flatpak install flathub com.obsproject.Studio -y
# flatpak install flathub com.visualstudio.code -y
# flatpak install flathub com.flashforge.FlashPrint -y

# flashprint
https://en.fss.flashforge.com/10000/software/f186e88806341f4e694728bf2ec68c4e.deb

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
rm steam.deb
# i386 is needed for steam to launch
sudo dpkg --add-architecture i386

# VPN
wget https://installers.privateinternetaccess.com/download/pia-linux-3.5.5-08091.run
wait
chown "$username":"$username" pia-linux-3.5.5-08091.run
./pia-linux-3.5.5-08091.run
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
rm -rf Nordzy-cursors


echo "Installing Gnome Extensions"
sleep 2
# Extensions - will need to be customized still
# After full install dwl Alt+tab and User Themes - versions are not compatible between stable and testing branches.
mkdir -p /home/"$username"/.local/share/gnome-shell/extensions
cp -R dotlocal/share/gnome-shell/extensions/* /home/"$username"/.local/share/gnome-shell/extensions/
chmod -R 777 /home/"$username"/.local/share/gnome-shell/extensions

# Removing zip files and stuff
rm ./FiraCode.zip ./Meslo.zip
rm -r dotlocal
rm -r scripts

# Used in fstab
mkdir -p /media/Working-Storage
mkdir -p /media/Archived-Storage




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
su "$username"
gsettings set org.gnome.desktop.interface clock-format 24h
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 04
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 2500
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.background picture-options 'spanned'
gsettings set org.gnome.shell favorite-apps "['com.google.Chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.libreoffice.LibreOffice.writer.desktop', 'org.gnome.Calculator.desktop', 'md.obsidian.Obsidian.desktop', 'com.visualstudio.code.desktop', 'code.desktop', 'com.discordapp.Discord.desktop']"
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:backspace']"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "tilix"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "tilix"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Primary><Alt>T"
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable aztaskbar@aztaskbar.gitlab.com
# gnome-extensions enable burn-my-windows@schneegans.github.com
gnome-extensions enable awesome-tiles@velitasali.com
gnome-extensions enable blur-my-shell@aunetx



echo "After rebooting, install Steam then run Script 3.sh for Nvidia drivers." 
echo "Skip 3.sh if you are not using Nvidia hardware."
wait 10
reboot



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
