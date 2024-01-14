# Debian-install
Install as a headless system, no DE at all.
Install your GRUB though.

This script will install Gnome-core and the apps I use as well as drivers and fonts, no bloat. 

### Notes:
There are a couple sections that will ask questions, one at the beginning to choose Stable or Testing branches. Another at the end to apply necessary drivers and kernal update if you're installing on a Microsoft Surface Device.

### Credits:
- The "usenala" script is from https://github.com/ChrisTitusTech/Debian-titus
- The surface bits are from: https://github.com/linux-surface/linux-surface/wiki
 
### To install:

```
sudo su

apt update

apt install git -y

git clone https://github.com/Piercing666/debian-install

cd debian-install

chmod u+x install.sh

./install.sh
