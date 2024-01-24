# Debian-install
This script will automate the install of all the GUI stuff needed in Debian 12. All the drivers/fonts/apps that I use on my Daily Driver.

Still a Beta, one day I'll polish it and compile into a single script. 


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
  
- "testing.sh" will change your Source.list to test branch.
  
- These scrips must be ran in order. Any deviation will break you system. The "3.sh" "surface" and "testing" scripts are optional. On brandnew hardware I highly recommend testing. 

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
