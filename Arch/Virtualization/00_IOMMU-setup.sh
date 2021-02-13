#!/bin/bash

# Run this first
# Set up IOMMU for PCI Passthrough

if [[ $(cat /etc/*-release | grep ID_LIKE) = "ID_LIKE=arch" ]]; then 
    if [[ -n $(LC_ALL=C lscpu | grep Virtualization) ]]; then


        sudo pacman -Syy
        sudo pacman -S --noconfirm vim

        # need to make sed
        # currently hardcoding GTX 1060 as blocked
        mkdir ~/backups
        cp /etc/default/grub ~/backups/etc-default-grub.orig
        sudo /bin/sh -c "echo '# GRUB_CMDLINE_LINUX_DEFAULT=\"quiet intel_iommu=on vfio-pci.ids=10de:1c03,10de:10f1 i915.enable_gvt=1\"' >> /etc/default/grub"
        sudo vim /etc/default/grub
        # #GRUB_CMDLINE_LINUX_DEFAULT="quiet"
        # # Enable intel GVT-g
        # GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on i915.enable_gvt=1"
        
        # Enable Kernel Modules
        cp /etc/modules ~/backups/etc-modules.orig
        sudo /bin/sh -c "echo '# Modules required for PCI passthrough
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd

# Modules required for Intel GVT
kvmgt
exngt
vfio-mdev' >> /etc/modules"
        
        echo "/etc/modules: "
        cat /etc/modules

        sudo /bin/sh -c "echo '# MODULES=(... vfio_pci vfio vfio_iommu_type1 vfio_virqfd ...)
        # Also, ensure that the modconf hook is included in the HOOKS list of mkinitcpio.conf: 
        # HOOKS=(... modconf ...)' >> /etc/mkinitcpio.conf"

        sudo vim /etc/mkinitcpio.conf

        sudo mkinitcpio -P
        sudo grub-mkconfig -o /boot/grub/grub.cfg


    else
        echo "CPU does not support virtualization"
    fi
else
    echo "This script is for Arch based distros only."
fi