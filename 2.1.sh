
#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)


apt update && upgrade -y

# Gnome-extensions 
gnome-extensions install aztaskbar@aztaskbar.gitlab.com -y
gnome-extensions install appindicatorsupport@rgcjonas.gmail.com -y
gnome-extensions install awesome-tiles@velitasali.com -y
gnome-extensions install blur-my-shell@aunetx -y
gnome-extensions install burn-my-windows@schneegans.github.com -y
gnome-extensions install Vitals@CoreCoding.com -y


apt update && upgrade -y


gnome-extensions enable aztaskbar@aztaskbar.gitlab.com -y
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com -y
gnome-extensions enable awesome-tiles@velitasali.com -y
gnome-extensions enable blur-my-shell@aunetx -y
gnome-extensions enable burn-my-windows@schneegans.github.com -y
gnome-extensions enable Vitals@CoreCoding.com -y
