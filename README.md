# Debian-install
This script will automate the install of a very vanilla Gnome Core and all the drivers fonts and programs that I use on my Daily Driver/Gaming rig/Tablets.
This is divided into sections so you can install only what you need.


### Notes:
- I recommend an up-to-date copy of the netinst.iso from their website.
- Install Debian as a headless system, no DE at all.
- Do install the GRUB.
- Reboot and follow the To install instructions
  
- "1.sh" to install Gnome-shell and a few adjustments.
  
- "2.sh" will install applications and fonts (it takes a minute to run so I'll usually edit settings and preferences while it runs).
  
- "3.sh" will install Nvidia drivers (if you dont have a Nvidia GPU skip this one).
  
- "Surface.sh" will install the necessary drivers to get a Microsoft Surface running on Debian (skip if not a Surface).
  
- "testing.sh" will change your Source.list to test branch. This is recommended if you are both running brandnew hardware and gameing. 
  
- These scrips must be ran in order. Any deviation will break your system. The "3.sh" "Surface.sh" and "testing.sh" scripts are hardware based/optional.

- If you have multiple harddrives in your system, after you run all the scripts, edit your fstab to auto-mount your drives on boot.

### Credits:
- The "usenala" script "Beautiful Bash" are from https://github.com/ChrisTitusTech/Debian-titus
- The surface bits are from: https://github.com/linux-surface/linux-surface/wiki but compiled into this script by me.

 
### To install:

```
sudo su

apt install git -y

git clone https://github.com/Piercing666/debian-install

chmod -R 777 debian-install

cd debian-install

./1.sh

then continue from there after each reboot.
