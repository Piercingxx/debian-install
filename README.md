# Debian-install
This script will automate the install of a very vanilla Gnome Core and all the drivers fonts and programs that I use on my Daily Driver/Gaming rig/Tablets.
This is divided into sections so you can install only what you need.


### Notes:
- I recommend an up-to-date copy of the netinst.iso from Debian's website.
- Install Debian as a headless system, no DE at all.
- Do install the GRUB.
- Reboot and follow the To install instructions

#### *** These scrips must be ran in order. Any deviation will break your system. The "3.sh" "Surface.sh" and "testing.sh" scripts are hardware based/optional. ***
  
- "1.sh" to install Gnome-shell and a few adjustments.
  
- "2.sh" will install applications, fonts, cursors, and customize settings (it takes several minutes to run).

- "2b.sh" is very quick and adjusts extension settings, unfortionately there needs to be a reboot before and after for these to be applied.

- If you plan on using Steam then you need to open Steam at this point and fully install it BEFORE you install 3.sh. If you install Steam after 3.sh it is a headache.
  
- "3.sh" will install Nvidia drivers (if you dont have a Nvidia GPU skip this one).
  
- "Surface.sh" will install the necessary drivers to get a Microsoft Surface running on Debian (skip if not a Surface).
  
- "testing.sh" will change your Source.list to test branch.
  
- If you have multiple harddrives in your system, after you run all the scripts, edit your fstab to auto-mount your drives on boot.

### Credits:
- The "usenala" script and "Beautiful Bash" are from https://github.com/ChrisTitusTech/Debian-titus
- The surface bits are from: https://github.com/linux-surface/linux-surface/wiki but compiled into this script by me.

 
### To install:

Boot into your headless system and login with the user name and password you just created. Then

``` sudo su ```

Then install Git

``` apt install git -y ```

After Git installs:

``` git clone https://github.com/Piercing666/debian-install ```

Then change the Mod:

``` chmod -R 777 debian-install ```

Then cd into install folder

``` cd debian-install ```

Run the first script

``` ./1.sh ```

After the system reboots openTerminal (not kitty), sudo su, and cd into install folder and run second script:

``` sudo su ```
``` cd debian-install ```
``` ./2.sh ```

At this point run Steam and fully install it. 
After setting up Steam you can install your Nvidia drivers, if you dont have a Nvidia GPU then skip 3.sh.
After 2.sh kitty will be fully setup is good to be used. You can choose to purge gnome-terminal at that point if you wish.
