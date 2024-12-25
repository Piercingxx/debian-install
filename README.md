# Debian-install
This script will automate the install of a very vanilla Gnome Core and all the drivers fonts and programs that I use on my Daily Driver/Gaming rig/Tablets.
This is divided into sections so you can install only what you need.


### Notes:
- I recommend an up-to-date copy of the netinst.iso from Debian's website.
- Install Debian as a headless system, no DE at all.
- Do install GRUB.
- Reboot and follow the To install instructions

#### *** These scrips must be ran in order. Any deviation will break your system. The "nvidia.sh" "Surface.sh" and "testing.sh" scripts are hardware based/optional. ***
  
- "1.sh" to install Gnome-shell and a few adjustments.
  
- "2.sh" will install applications, fonts, cursors, and customize settings (it takes several minutes to run).

- If you plan on using Steam then you need to open Steam at this point and fully install it BEFORE you install nvidia.sh. If you install Steam after nvidia.sh it is a headache.
  
- "nvidia.sh" will install Nvidia drivers (if you don't have a Nvidia GPU skip this one).
  
- "Surface.sh" will install the necessary drivers to get a Microsoft Surface running on Debian (skip if not a Surface).
  
- "testing.sh" will change your Source.list to test branch.

- "hyprland-setup" will install hyprland on your Debian Testing with Gnome system.
  
- If you have multiple hard drives in your system, after you run all the scripts, edit your fstab to auto-mount your drives on boot.


 
### To install:

1. Boot into your headless system and login with the user name and password you just created. Then:

``` sudo apt install git -y ```


2. After Git installs:

``` git clone https://github.com/PiercingXX/debian-install ```


3. Change Mod:

``` sudo chmod -R u+x debian-install/ ```


4. cd into install folder:

``` cd debian-install ```


5. Run the first script:

``` sudo su ```

``` ./1.sh ```


6. After the system reboots open Terminal:

``` cd debian-install ```

``` sudo su ```

``` ./2.sh ```


7. After the system reboots open Terminal (do not sudo su this one):

``` cd debian-install ```

``` ./3.sh ```


8. Now you open Steam and allow to update BEFORE running "nvidia.sh". You can also login (don't forget to change compatibility settings). You can install games now or after you finish the install, not both.


9. Open Kitty and run:
``` sudo apt purge gnome-terminal -y ```


### **Optional** 


9. Install Nvidia drivers if you want/need them. (If you are running a Microsoft Surface device you can skip this unless you also want to game or edit videos on the device):

``` ./nvidia.sh ```


9. Beautiful Bash:

``` git clone https://github.com/christitustech/mybash ```

``` cd mybash ```

``` ./setup.sh ```


11. If you are using a Microsoft Surface device you can now run the script:

``` ./Surface.sh ```


12. On the newest hardware you will want to change into the Testing branch of Debian (note, you can not change back without a full reinstall), use:

``` ./testing.sh ```

13. If you want to run Hyprland on Debian you must first run scripts 1, 2, 3, & testing.sh. You can then run:

``` ./hyprland-setup.sh '''

14. Run:

``` rm -r /home/$USERNAME/debian-install ```


If you come across any issues please let me know!







### Credits:
- The "usenala" script and "Beautiful Bash" are from https://github.com/ChrisTitusTech/Debian-titus
- The surface bits are from: https://github.com/linux-surface/linux-surface/wiki but compiled into this script by me.
