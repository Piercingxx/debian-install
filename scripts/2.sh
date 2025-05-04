#!/bin/bash
# https://github.com/Piercing666

username=$(id -u -n 1000)
builddir=$(pwd)

echo "Starting Script 2.sh"
sleep 2

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
  awk '{print}' <<<"Network connectivity is required to continue."
  exit
fi

echo "Updating Repositories"
sudo apt update && upgrade -y
wait

# Making .config and.fonts Directories
cd "$builddir" || exit
mkdir -p /home/"$username"/.config
chown -R "$username":"$username" /home/"$username"/.config
mkdir -p /home/"$username"/.fonts
chown -R "$username":"$username" /home/"$username"/.fonts
mkdir -p /home/"$username"/.icons
chown -R "$username":"$username" /home/"$username"/.icons
mkdir -p /home/"$username"/Pictures/backgrounds
chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds

# Installing important things && stuff && some dependencies
echo "Installing Programs and Drivers"
sudo apt install dbus-x11 -y
sudo apt install cups -y
sudo apt install util-linux -y
sudo apt install xdg-utils -y
sudo apt install libnvidia-egl-wayland -y
sudo apt install build-essential -y
sudo apt install nautilus -y
sudo apt install gdebi -y
sudo apt install fuse -y
sudo apt install libfuse2 -y
sudo apt install x11-xserver-utils -y
sudo apt install dh-dkms -y
sudo apt install devscripts -y
sudo apt install fonts-noto-color-emoji -y
sudo apt install zip unzip gzip tar -y
sudo apt install make -y
sudo apt install linux-headers-generic -y
sudo apt install seahorse -y
sudo apt install gnome-calculator -y
sudo apt install rename -y
sudo apt install neofetch -y
sudo apt install mpv -y
sudo apt install gparted -y
sudo apt install curl -y
sudo apt install gh -y
sudo apt install lua5.4 -y
sudo apt install gnome-disk-utility -y
sleep 2
flatpak install flathub net.waterfox.waterfox -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub org.libreoffice.LibreOffice -y
flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
flatpak install flathub org.darktable.Darktable -y
flatpak install flathub org.gnome.SimpleScan -y
flatpak install flathub org.blender.Blender -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub io.missioncenter.MissionCenter -y
flatpak install flathub com.tomjwatson.Emote -y

# VSCode
wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e170252f762678dec6ca2cc69aba1570769a5d39/code_1.88.1-1712771838_amd64.deb"
wait
dpkg -i code_1.88.1-1712771838_amd64.deb
wait
rm code_1.88.1-1712771838_amd64.deb

# Synology Drive
wget "https://global.download.synology.com/download/Utility/SynologyDriveClient/3.4.0-15724/Ubuntu/Installer/synology-drive-client-15724.x86_64.deb"
wait
sudo dpkg -i synology-drive-client-15724.x86_64.deb
wait

# Synology Chat
wget "https://global.synologydownload.com/download/Utility/ChatClient/1.2.2-0222/Ubuntu/x86_64/Synology%20Chat%20Client-1.2.2-0222.deb"
wait
sudo dpkg --force-all -i Synology%20Chat%20Client-1.2.2-0222.deb
wait

# steam
wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
wait
sudo dpkg -i steam.deb
wait
rm steam.deb
# i386 is needed for steam to launch
sudo dpkg --add-architecture i386

# FlashForge
# wget "https://en.fss.flashforge.com/10000/software/e02d016281d06012ea71a671d1e1fdb7.deb"
# chown "$username":"$username" e02d016281d06012ea71a671d1e1fdb7.deb

sudo apt update
wait
sudo apt upgrade -y
wait

echo "Installing Fonts"
sleep 2
# Installing fonts
cd "$builddir" || exit
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
chmod -R 777 FiraCode.zip
unzip FiraCode.zip -d /home/"$username"/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
chmod -R 777 Meslo.zip
unzip Meslo.zip -d /home/"$username"/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/"$username"/.fonts/
chown -R "$username":"$username" /home/"$username"/.fonts
apt install fonts-font-awesome fonts-noto-color-emoji -y
apt install ttf-mscorefonts-installer -y
apt install fonts-terminus -y

# Reloading Font
fc-cache -vf
wait

# Extensions
echo "Gnome Extensions"
sleep 2
sudo apt install gnome-shell-extension-appindicator -y
sudo apt install gnome-shell-extension-gsconnect -y
sudo apt install gnome-shell-extension-caffeine -y
# App Icons Taskbar
wget https://gitlab.com/AndrewZaech/aztaskbar/-/archive/main/aztaskbar-main.tar
gnome-extensions install aztaskbar-main.tar
# Awesome Tiles
git clone https://github.com/velitasali/gnome-shell-extension-awesome-tiles.git
chmod -R u+x gnome-shell-extension-awesome-tiles
cd gnome-shell-extension-awesome-tiles || exit
./install.sh local-install
cd ..
rm -rf gnome-shell-extension-awesome-tiles
# Worthless Gaps
git clone https://github.com/mipmip/gnome-shell-extensions-useless-gaps.git
chmod -R u+x nome-shell-extensions-useless-gaps
cd gnome-shell-extensions-useless-gaps || exit
./install.sh local-install
# Just Perfection
# Blur My Shell

#Nautilus Customization
sudo apt install gnome-sushi -y
sudo apt install imagemagick nautilus-image-converter -y
sudo apt install nautilus-admin -y
sudo apt install gir1.2-gtk-4.0 -y
git clone https://github.com/Stunkymonkey/nautilus-open-any-terminal.git
cd nautilus-open-any-terminal || exit
make
sudo make install schema
glib-compile-schemas /usr/share/glib-2.0/schemas
cd "$builddir" || exit
rm -rf nautilus-open-any-terminal

# Removing zip files and stuff
rm -rf FiraCode.zip
rm -rf Meslo.zip

# Used for fstab
mkdir -p /media/Working-Storage
mkdir -p /media/Archived-Storage
chown "$username":"$username" /home/"$username"/media/Archived-Storage
chown "$username":"$username" /home/"$username"/media/Working-Storage

sudo apt update && upgrade -y
wait
sudo apt full-upgrade -y
wait
sudo apt install -f
wait
dpkg --configure -a
sudo apt install --fix-broken
wait
sudo apt autoremove -y
sudo apt update && upgrade -y
wait
flatpak update -y

read -r -p "2.sh complete. Reboot and run Steam, after you can install Nvidia drivers (Do not install Nvidia Proprietary Drivers if using the Surface Kernal)"



