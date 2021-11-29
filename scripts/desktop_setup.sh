#!/bin/bash
# import Gnome desktop settings

# to save settings
#dconf dump / > dconf-settings.ini

dconf load / < dconf-settings.ini
