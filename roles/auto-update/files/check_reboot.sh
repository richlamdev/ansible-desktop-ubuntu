#!/bin/bash

LOG_FILE="/var/log/reboot_check.log"

if [ -f /var/run/reboot-required ]; then
  echo "Reboot required on $(date)" >>"$LOG_FILE"
  # Uncomment the next line to automatically reboot
  /sbin/reboot
fi
