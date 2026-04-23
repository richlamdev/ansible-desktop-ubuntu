#!/bin/bash
sleep 2
gdbus call --session \
  --dest org.gnome.ScreenSaver \
  --object-path /org/gnome/ScreenSaver \
  --method org.gnome.ScreenSaver.SetActive true
