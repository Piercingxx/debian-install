#!/bin/bash

# https://github.com/piercingxx

username=$(id -u -n 1000)
builddir=$(pwd)

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi



sudo apt update
sudo apt upgrade -y

# Dependancies for hyprlock/idle
sudo apt install libsdbus-c++-dev -y
sudo apt install libhyprlang-dev -y
sudo apt install libpam0g-dev -y
sudo apt install libgbm-dev -y
sudo apt install libdrm-dev -y
sudo apt install libmagic-dev -y
sudo apt install libhyprutils0 -y
sudo apt install libhyprutils-dev -y
sudo apt install hyprland-protocols -y
sudo apt install hyprwayland-scanner -y


# Installing main shit
sudo apt install hyprland -y
sudo apt install hyprpaper -y
sudo apt install rofi -y
sudo apt install fuzzel -y
sudo apt install waybar -y
sudo apt install wayland-protocols -y
sudo apt install wl-clipboard -y
sudo apt install wlogout -y
sudo apt install pavucontrol -y
sudo apt install grim -y 
sudo apt install slurp -y
sudo apt install cliphist -y

# Bluetooth
#sudo apt install bluez -y
#sudo apt install blueman -y


# Clone and build hyprlock
printf "${NOTE} Installing hyprlock...\n"
if git clone --recursive -b $lock_tag https://github.com/hyprwm/hyprlock.git; then
    cd hyprlock || exit 1
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
	cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    if sudo cmake --install build 2>&1 | tee -a "$MLOG" ; then
        printf "${OK} hyprlock installed successfully.\n" 2>&1 | tee -a "$MLOG"
    else
        echo -e "${ERROR} Installation failed for hyprlock." 2>&1 | tee -a "$MLOG"
    fi
    #moving the addional logs to Install-Logs directory
    mv $MLOG ../Install-Logs/ || true 
    cd ..
else
    echo -e "${ERROR} Download failed for hyprlock." 2>&1 | tee -a "$LOG"
fi


# hypridle
printf "${NOTE} Installing hypridle...\n"
if git clone --recursive -b $idle_tag https://github.com/hyprwm/hypridle.git; then
    cd hypridle || exit 1
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
	cmake --build ./build --config Release --target hypridle -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
    if sudo cmake --install ./build 2>&1 | tee -a "$MLOG" ; then
        printf "${OK} hypridle installed successfully.\n" 2>&1 | tee -a "$MLOG"
    else
        echo -e "${ERROR} Installation failed for hypridle." 2>&1 | tee -a "$MLOG"
    fi
    #moving the addional logs to Install-Logs directory
    mv $MLOG ../Install-Logs/ || true 
    cd ..
else
    echo -e "${ERROR} Download failed for hypridle." 2>&1 | tee -a "$LOG"
fi



# .config Dot Files
    git clone https://github.com/Piercingxx/piercing-dots.git
        chmod -R u+x piercing-dots
        chown -R "$username":"$username" piercing-dots
        cp -Rf "piercing-dots" /home/"$username"/.config/
        chown "$username":"$username" -R /home/"$username"/.config/*
