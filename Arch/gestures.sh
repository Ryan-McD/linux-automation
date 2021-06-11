#!/bin/bash
sudo gpasswd -a $USER input
newgrp input
sudo pacman -S libinput-gestures gestures
libinput-gestures-setup autostart
libinput-gestures-setup start


# Gestures
echo "gesture swipe right 4 xdotool key Super+Control+Right" >> ~/.config/libinput-gestures.conf
echo "gesture swipe left 4 xdotool key Super+Control+Left" >> ~/.config/libinput-gestures.conf
echo "gesture swipe right 3 xdotool key Alt+Right" >> ~/.config/libinput-gestures.conf
echo "gesture swipe left 3 xdotool key Alt+Left" >> ~/.config/libinput-gestures.conf

libinput-gestures-setup restart
