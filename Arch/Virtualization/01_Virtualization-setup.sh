#!/bin/bash

# This is a script to set up Virtualization with KVM on an Arch Linux based host

if [[ $(cat /etc/*-release | grep ID_LIKE) = "ID_LIKE=arch" ]]; then 
    if [[ -n $(LC_ALL=C lscpu | grep Virtualization) ]]; then

        sudo pacman -Syy

        # Install KVM Packages
        sudo pacman -S --noconfirm qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat qemu-arch-extra
        sudo pacman -S --noconfirm ebtables iptables
        sudo pacman -S --noconfirm libguestfs

        # Enable UEFI (requires yay or Arcolinux)
        sudo pacman -S --noconfirm edk2-ovmf

        # Enable libvirt
        sudo systemctl enable libvirtd.service
        sudo pacman -S --noconfirm vim


        sudo cp /etc/libvirt/libvirtd ~/backups/etc-libvirt-libvirtd.orig
        # need to make sed replacement
        # Set the UNIX domain socket group ownership to libvirt, (around line 85)
        # unix_sock_group = "libvirt"
        sudo /bin/sh -c "echo '# unix_sock_group = \"libvirt\"' >> /etc/libvirt/librtd.conf"

        # Set the UNIX socket permissions for the R/W socket (around line 102)
        # unix_sock_rw_perms = "0770"
        sudo /bin/sh -c "echo '# unix_sock_rw_perms = \"0770\"' >> /etc/libvirt/libvirtd.conf"

        sudo vim /etc/libvirt/libvirtd.conf
        # sed 's/unix_sock_group = "libvirt"/libvirt/' /etc/libvirt/libvirtd.conf > temp.txt 
        # sudo cp /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.orig
        # sudo mv -f temp.txt /etc/libvirt/libvirtd.conf


        sudo usermod -a -G libvirt $(whoami)
        newgrp libvirt
        sudo systemctl restart libvirtd.service

# Enable nested virtualization
        sudo /usr/bin/modprobe -r kvm_intel
        sudo /usr/bin/modprobe kvm_intel nested=1
        if [[ -z $(systool -m kvm_intel -v | grep nested | grep Y) ]]
            sudo /bin/sh -c "echo 'options kvm_intel nested=1' >> /etc/modprobe.d/kvm_intel.conf"
        fi

# Enable Huge pages - Assuming 8GB for VM - https://wiki.archlinux.org/index.php/Kvm#Enabling_huge_pages
        sudo /bin/sh -c "echo 'hugetlbfs       /dev/hugepages  hugetlbfs       mode=01770,gid=965        0 0' >> /etc/fstab"
        sudo umount /dev/hugepages
        sudo mount /dev/hugepages
        sudo /bin/sh -c "echo 4400 > /proc/sys/vm/nr_hugepages"
    else
        echo "CPU does not support virtualization"
    fi
else
    echo "This script is for Arch based distros only."
fi