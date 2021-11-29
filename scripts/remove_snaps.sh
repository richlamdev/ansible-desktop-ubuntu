#!/bin/bash
set -x

sudo snap list | awk '!/Name/ && !/snapd/ {print $1}' | sort -r | while read -r line; do
sudo snap remove $line ; done || true
sudo systemctl stop snapd || true
sudo umount -lf /snap/core/* || true
sudo apt purge snapd || true
