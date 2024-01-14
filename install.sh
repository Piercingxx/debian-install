#!/bin/bash

# https://github.com/Piercing666

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

# Option to choose testing or stable
PS3='Install Stable or Testing Branch?: '
branch=("1:Stable" "2:Testing")
    select fav in "${branch[@]}"; do
        case $fav in
            "1:Stable")
                echo "Applying Stable branch repositories"
sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://deb.debian.org/debian/ buster main contrib non-free
deb http://security.debian.org/debian-security stable-security/updates main contrib non-free
deb https://deb.debian.org/debian/ stable-updates main contrib non-free
deb https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main
deb-src https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main 
deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
                break
                ;;
            "2:Testing")
            echo "Changing to Testing branch repositories"
sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb http://security.debian.org/debian-security testing-security/updates main contrib non-free
deb https://deb.debian.org/debian/ testing-updates main contrib non-free
deb https://deb.debian.org/debian/ testing contrib non-free non-free-firmware main
deb-src https://deb.debian.org/debian/ testing contrib non-free non-free-firmware main 
deb-src https://deb.debian.org/debian/ testing-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done


# Making dir
cd $builddir
mkdir -p /home/$username/.fonts
mkdir -p /var/lib/usbmux/.config


# Install Essentials
apt install nala -y
nala install wget flatpak gnome-software-plugin-flatpak -y 


# Add additional repositories
flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-repo-debian12-12-3-local_12.3.2-545.23.08-1_amd64.deb
dpkg -i cuda-repo-debian12-12-3-local_12.3.2-545.23.08-1_amd64.deb
cp /var/cuda-repo-debian12-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
nala update && upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a
nala install --fix-broken
apt update
apt upgrade
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


nala update && upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a


# Actually enabling the admends just made
systemctl enable gdm
systemctl enable gdm3
systemctl set-default graphical.target
apt update && upgrade -y
flatpak update -y
flatpak upgrade -y
apt autoremove -y


# Installing other less important but still important Programs and drivers
nala install tilix -y
nala install gh -y
nala install build-essential -y
nala install lua5.4 -y
nala install neofetch -y
nala install neovim -y
nala install nvidia-driver -y
nala install cuda-toolkit-12-3 cuda-drivers -y
nala install blender -y
nala install freecad  -y
nala install inkscape  -y
nala install gparted  -y
nala install scribus  -y
nala install librecad  -y
nala install gnome-tweaks  -y
nala install htop -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.synology.SynologyDrive -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install --user https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
nala install nvtop -y 


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


# Use nala
bash scripts/usenala


# Is this a Microsoft Surface Device?
PS3='Is this A Microsoft Surface Device?: '
isSurface=("Yes" "No")
select fav in "${isSurface[@]}"; do
    case $fav in
        "Yes")
            echo "Installing Surface Stuffs!"
	    apt update && upgrade -y
        wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc
        gpg --dearmor 
        dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg
        echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main"
	    tee /etc/apt/sources.list.d/linux-surface.list
        apt update
        apt install linux-image-surface linux-headers-surface libwacom-surface iptsd
        apt install linux-surface-secureboot-mok
        update-grub
	    break
            ;;
	"No")
	    echo "Not A Surface Device"
	    break
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done


apt update
apt upgrade -y
apt full-upgrade -y
sudo apt install -f
sudo dpkg --configure -a
apt update
apt upgrade
flatpak update
apt autoremove
sudo reboot
