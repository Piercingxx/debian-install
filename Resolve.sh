#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<< "Network connectivity is required to continue."
    exit
fi

apt update && upgrade -y
wait


echo "Installing Dependencies for DaVinci Resolve."
sleep 3
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




wget https://swr.cloud.blackmagicdesign.com/DaVinciResolve/v18.6.5/DaVinci_Resolve_18.6.5_Linux.zip?verify=1710152971-%2BcJfEuCjESaemO3IFsAvFPbB08xn%2BkHZCA8Px2%2F6Yxw%3D
cd /home/"$username"/Downloads
unzip DaVinci_Resolve_18.6.5_Linux.zip
chown "$username":"$username" DaVinci_Resolve_18.6.5_Linux.run
./DaVinci_Resolve_18.6.5_Linux.run

wait


rm /opt/resolve/libs/libglib-2.0.so*
rm /opt/resolve/libs/libgio-2.0.so*
rm /opt/resolve/libs/libgmodule-2.0.so*
rm /opt/resolve/libs/libgobject-2.0.so*



apt update && upgrade -y
wait


echo "The first time you launch Resolve the splash will freeze."
echo "Launch Btop and terminate Davince Resolve splash."
echo "It will then launch without any issues."

sleep 60

