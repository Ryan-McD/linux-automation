#!/bin/bash

####FEDORA INSTALL####
# Install Requirements
sudo dnf install \
            xdotool \
            wmctrl \
            git

# Add Groups
sudo gpasswd -a $USER input
exec sg input newgrp $(id -gn)

# Add Multitouch Gestures
ORG_DIR=$PWD
cd /usr/src
sudo git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install
libinput-gestures-setup autostart
libinput-gestures-setup start
cd $ORG_DIR
#############################

# Gestures
echo "gesture swipe right 4 xdotool key Super+Control+Right" >> ~/.config/libinput-gestures.conf
echo "gesture swipe left 4 xdotool key Super+Control+Left" >> ~/.config/libinput-gestures.conf
echo "gesture swipe right 3 xdotool key Alt+Right" >> ~/.config/libinput-gestures.conf
echo "gesture swipe left 3 xdotool key Alt+Left" >> ~/.config/libinput-gestures.conf

libinput-gestures-setup restart
