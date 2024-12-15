# Debian-install
This script will automate the install of a very vanilla Gnome Core and all the drivers fonts and programs that I use on my Daily Driver/Gaming rig/Tablets.
This is divided into sections so you can install only what you need.


### Notes:
- I recommend an up-to-date copy of the netinst.iso from Debian's website.
- Install Debian as a headless system, no DE at all.
- Do install GRUB.
- Reboot and follow the To install instructions

#### *** These scrips must be ran in order. Any deviation will break your system. The "3.sh" "Surface.sh" and "testing.sh" scripts are hardware based/optional. ***
  
- "1.sh" to install Gnome-shell and a few adjustments.
  
- "2.sh" will install applications, fonts, cursors, and customize settings (it takes several minutes to run).

- If you plan on using Steam then you need to open Steam at this point and fully install it BEFORE you install 3.sh. If you install Steam after 3.sh it is a headache.
  
- "3.sh" will install Nvidia drivers (if you don't have a Nvidia GPU skip this one).
  
- "Surface.sh" will install the necessary drivers to get a Microsoft Surface running on Debian (skip if not a Surface).
  
- "testing.sh" will change your Source.list to test branch.
  
- If you have multiple hard drives in your system, after you run all the scripts, edit your fstab to auto-mount your drives on boot.

### Credits:
- The "usenala" script and "Beautiful Bash" are from https://github.com/ChrisTitusTech/Debian-titus
- The surface bits are from: https://github.com/linux-surface/linux-surface/wiki but compiled into this script by me.

 
### To install:

1. Boot into your headless system and login with the user name and password you just created. Then:

``` sudo apt install git -y ```


3. After Git installs:

``` git clone https://github.com/PiercingXX/debian-install ```


4. Change Mod:

``` sudo chmod -R u+x debian-install/ ```


5. cd into install folder:

``` cd debian-install ```


6. Run the first script:

``` sudo su ```

``` ./1.sh ```


  7.1 After the system reboots open Terminal (not kitty):

``` cd debian-install ```

``` sudo su ```

``` ./2.sh ```


  7.2 Beautiful Bash:

``` git clone https://github.com/christitustech/mybash ```

``` cd mybash ```

``` ./setup.sh ```



8. Now you can open Steam and login (dont forget to change compatability settings). You can install games now or after you finish the install, not both.
    You can also feel free to apt purge gnome-terminal and just use Kitty as your main terminal CTRL+ALT+T will launch this.


9. Install Nvidia drivers if you want/need them. (If you are running a Microsoft Surface device you can skip this unless you also want to game or edit videos on the device):
   
``` ./3.sh ```


 10. If you are using a Microsoft Surface device you can now run the script:

``` ./Surface.sh ```


 11. On the newest hardware you will want to change into the Testing branch of Debian (note, you can not change back without a full reinstall), use:

``` ./testing.sh ```


 12. Run:

``` rm -r /home/$USERNAME/debian-install ```


If you come across any issues please let me know!
