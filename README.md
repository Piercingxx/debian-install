# Debian-install
This script will automate the install of all the GUI stuff needed in Debian 12. All the drivers/fonts/apps that I use on my Daily Driver.

Still a Beta, one day I'll polish it and compile into a single script. 


### Notes:
- I recommend an up-to-date copy of the netinst.iso from their website: https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso
- Install Debian as a headless system, no DE at all.
- Do install the GRUB.
- Reboot into terminal and follow the To install instructions
- The script will update your Sources.list 
- If you come across any install errors, let me know. 

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

chmod u+x 1.sh

./1.sh
