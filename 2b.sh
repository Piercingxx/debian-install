#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

# Modify Gnome Extensions
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
dconf write /org/gnome/shell/extensions/awesome-tiles/gap-size-increments "1" && echo "Awesome Tiles Gap Size Increments: 1"
dconf write /org/gnome/shell/extensions/aztaskbar/favorites "false" && echo "AzTaskbar Favorites: False"
dconf write /org/gnome/shell/extensions/aztaskbar/main-panel-height "33" && echo "AzTaskbar Main Panel Height: 33"
dconf write /org/gnome/shell/extensions/aztaskbar/show-panel-activities-button "false" && echo "AzTaskbar Show Panel Activities Button: False"
dconf write /org/gnome/shell/extensions/aztaskbar/icon-size "23" && echo "AzTaskbar Icon Size: 23"
dconf write /org/gnome/shell/extensions/blur-my-shell/brightness "1.0" && echo "Blur My Shell Brightness: 1.0"

echo "Rebooting" && sleep 3
sudo reboot
