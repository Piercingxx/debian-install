#!/bin/bash

# https://github.com/piercingxx

username=$(id -u -n 1000)
builddir=$(pwd)

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

clear

sudo apt update
sudo apt upgrade -y

# Dependancies for hyprlock/idle
apt install libsdbus-c++-dev -y
apt install libhyprlang-dev -y
apt install libpam0g-dev -y
apt install libgbm-dev -y
apt install libdrm-dev -y
apt install libmagic-dev -y
apt install libhyprutils0 -y
apt install libhyprutils-dev -y
apt install hyprland-protocols -y
apt install hyprwayland-scanner -y


# Installing main shit
apt install hyprland -y
apt install hyprpaper -y
apt install rofi -y
apt install fuzzel -y
apt install waybar -y
apt install wayland-protocols -y
apt install wl-clipboard -y
apt install wlogout -y
apt install pavucontrol -y
apt install grim -y 
apt install slurp -y
apt install cliphist -y

# Bluetooth
apt install bluez -y
apt install blueman -y


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
clear

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
clear


git clone https://github.com/Piercingxx/Hyprland-Waybar
chmod -R u+x Hyprland-Waybar
cp -Rf Hyprland-Waybar/dots/* /home/"$username"/.config/
cd "$builddir" || exit
rm -Rf Hyprland-Waybar