# Debian-install
This script will automate the install of all the GUI stuff needed in Debian 12. All the drivers/fonts/apps that I use on my Daily Driver and my laptop & tablet (both Surface devices).

Still a Beta, one day I'll polish it, still need to add the Gnome extensions and figure out a way to automate Devinci Resolve Studio.



### Notes:
- I recommend an up-to-date copy of the netinst.iso from their website: https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso
- Install Debian as a headless system, no DE at all.
- Do install the GRUB.
- Reboot onto terminal and follow the To install instructions
- The script will update your Sources.list Repositories to either Stable or Testing. The stable branch still reaches back to Buster for cuda drivers.
- There are a couple sections that will ask questions, one at the beginning to choose Stable or Testing branches. Another at the end to apply necessary drivers and kernal update if you're installing on a Microsoft Surface Device.
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

chmod u+x install.sh

./install.sh
