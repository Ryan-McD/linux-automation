#!/bin/bash

# Find distro type
if [[ $(cat /etc/*-release | grep ID_LIKE) = "ID_LIKE=debian" ]]; then 
    distro="debian_based" 

    echo "Install optional software"
    #kodi
    apt remove kodi kodi-bin kodi-data
    apt purge kodi kodi-bin kodi-data
    apt-get install software-properties-common -y
    add-apt-repository ppa:team-xbmc/ppa
    apt update


    apt install openssh-server nfs-common gparted apcupsd -y
    #apt-get install kodi -y #does not install correct display manager
    #Timeshift
    add-apt-repository -y ppa:teejee2008/ppa
    apt install timeshift -y
    apt full-upgrade -y

elif [[ $(cat /etc/*-release | grep ID_LIKE) = "ID_LIKE=arch" ]]; then 
    distro="arch_based" 
    # update lists
    pacman -Syy #--noconfirm

    if [[ -n $"(lspci | grep 'Host bridge:' | grep Intel" ]]; then
        # Intel cpu
        pacman -S --noconfirm intel-ucode
    else
        pacman -S --noconfirm amd-ucode
    fi
    
    echo "Install optional software from arch-repos"
    pacman -S --noconfirm openssh gparted \
    terminator tmux lm_sensors lshw \
    powertop \
    flameshot \
    catfish \
    celluloid kdenlive mpv vlc rhythmbox \
    galculator flameshot \
    cheese

    # Arcolinux
    if [[ -n $"(cat/etc/*-release | grep arcolinux)" ]]; then
    echo "Install arcolinux exclusives"
    pacman -S --noconfirm bitwarden-bin \
    spotify spotifywm-git \
    timeshift timeshift-autosnap
    #plank
    pacman -S --noconfirm plank arcolinux-plank-git arcolinux-plank-themes-git

    fi

    pacman -Syu --noconfirm
fi


echo "Create directory /mnt/Media and assign to current user"
mkdir -p /mnt/Media
chown ctab579:ctab579 /mnt/Media

echo "modify fstab to mount NAS Media drive"
echo " " >> /etc/fstab
echo "10.11.1.111:/mnt/user/Media /mnt/Media nfs defaults,ro,noatime,noauto 0 0" >> /etc/fstab
echo "mounting drives"
mount -a
