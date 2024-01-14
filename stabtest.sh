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

# Making dir
cd $builddir
mkdir -p /home/$username/.fonts
mkdir -p /var/lib/usbmux/.config
mkdir -p /var/run/nvpd/.config


# Install Essential Programs part 1of2
apt install nala 
nala install wget flatpak gnome-software-plugin-flatpak -y 



# Add additional repositories
flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-repo-debian12-12-3-local_12.3.2-545.23.08-1_amd64.deb
dpkg -i cuda-repo-debian12-12-3-local_12.3.2-545.23.08-1_amd64.deb
cp /var/cuda-repo-debian12-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/


# Option to choose testing or stable
PS3='Install Stable or Testing Branch?: '
branch=("Stable" "Testing")
    select fav in "${branch[@]}"; do
        case $fav in
            "Stable")
                echo "Installing Stable!"
                    sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://deb.debian.org/debian/ buster main contrib non-free
                    deb http://security.debian.org/debian-security stable-security/updates main contrib non-free
                    deb https://deb.debian.org/debian/ stable-updates main contrib non-free
                    deb https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main
                    deb-src https://deb.debian.org/debian/ stable contrib non-free non-free-firmware main 
                    deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
                    nala update && upgrade -y
                    apt full-upgrade -y
                    sudo apt install -f
                    sudo dpkg --configure -a
                    nala install --fix-broken
                    apt update
                    apt upgrade
                    flatpak update
                ;;
            "Testing")
            echo "Installing Testing"
                    sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb http://security.debian.org/debian-security testing-security/updates main contrib non-free
                    deb https://deb.debian.org/debian/ testing-updates main contrib non-free
                    deb https://deb.debian.org/debian/ testing contrib non-free non-free-firmware main
                    deb-src https://deb.debian.org/debian/ testing contrib non-free non-free-firmware main 
                    deb-src https://deb.debian.org/debian/ testing-updates main contrib non-free"
                    sudo tee -a /etc/apt/sources.list
                    nala update && upgrade -y
                    apt full-upgrade -y
                    sudo apt install -f
                    sudo dpkg --configure -a
                    nala install --fix-broken
                    apt update
                    apt upgrade
                    flatpak update
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done


nala install gnome-core 


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
