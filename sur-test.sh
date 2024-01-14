#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)


# Is this a Microsoft Surface Device?
#!/bin/bash
PS3='Is this A Microsoft Surface Device?: '
isSurface=("Yes" "No")
select fav in "${isSurface[@]}"; do
    case $fav in
        "Yes")
            echo "Installing Surface Stuffs!"
	    apt update && upgrade -y
        wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc
        gpg --dearmor 
        dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg
        echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main"
	    tee /etc/apt/sources.list.d/linux-surface.list
        apt update
        apt install linux-image-surface linux-headers-surface libwacom-surface iptsd
        apt install linux-surface-secureboot-mok
        update-grub
        apt update && upgrade -y               
            ;;
	"No")
	    echo "Not A Surface Device"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
