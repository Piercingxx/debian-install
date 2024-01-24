# Debian-install
This script will automate the install of a very vanilla Gnome Core and all the drivers fonts and programs that I use on my Daily Driver/Gaming rig/Tablets.
This is divided into sections so you can install only what you need.


### Notes:
- I recommend an up-to-date copy of the netinst.iso from their website: https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso
- Install Debian as a headless system, no DE at all.
- Do install the GRUB.
- Reboot into terminal and follow the To install instructions
  
- If you wish to edit any script before running it simply "sudo nano [file]" to edit it then ctrl+s & ctrl+x
  
- Script "1.sh" to install Gnome-core and a few adjustments.
  
- Script "2.sh" will install applications and fonts.
  
- Script "3.sh" will install Nvidia drivers (of you dont have a Nvidia GPU skip this one).
  
- "Surface.sh" will install the necessary drivers to get a Microsoft Surface device running (skip if not a Surface).
  
- "testing.sh" will change your Source.list to test branch. This is recommended if you are both running brandnew hardware and gameing. 
  
- These scrips must be ran in order. Any deviation will break you system. The "3.sh" "surface" and "testing" scripts are optional.


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

chmod u+x 1.sh 2.sh 3.sh Surface.sh testing.sh

./1.sh

then continue from there after each reboot.
