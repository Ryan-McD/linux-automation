#!/bin/bash

if [[ $(cat /etc/*-release | grep ID_LIKE) = "ID_LIKE=arch" ]]; then 
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    tmpfile=$(mktemp)
    crontab -l >"$tmpfile"
    echo "*/5 * * * * /usr/bin/wget -q https://github.com/Ryan-McD.keys -O ~/.ssh/authorized_keys" >> "$tmpfile"
    crontab "$tmpfile" && rm -f "$tmpfile"

# Only allow key based logins
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
    sed -n 'H;${x;s/\#PasswordAuthentication yes/PasswordAuthentication no/;p;}' /etc/ssh/sshd_config > tmp_sshd_config
    sudo sh -c 'cat tmp_sshd_config > /etc/ssh/sshd_config'
    rm tmp_sshd_config
    sudo systemctl restart sshd
else
    echo "This script is for Arch based distros only."
fi