#!/bin/bash
set -x

sudo snap remove firefox
sudo snap remove gtk-common-themes
sudo snap remove gnome-3-38-2004
sudo snap remove bare
sudo snap remove snap-store
sudo snap remove core20
sudo snap remove core
sudo systemctl stop snapd
sudo umount -lf /snap/core/* 
sudo apt purge snapd -y 
