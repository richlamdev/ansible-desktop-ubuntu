#!/bin/bash
# Import/Export GNOME desktop settings

SAVED_FILE="dconf-settings.ini"

if [ "$1" == "save" ]; then
  # Save all GNOME settings to a file
  dconf dump / >"$SAVED_FILE"
  echo "Settings saved to $SAVED_FILE"

elif [ "$1" == "load" ]; then
  # Load all GNOME settings from a file
  if [ -f "$SAVED_FILE" ]; then
    dconf load / <"$SAVED_FILE"
    echo "Settings loaded from $SAVED_FILE"
  else
    echo "No saved settings file found! Expected file: $SAVED_FILE"
  fi

else
  echo "Usage: $0 {save|load}"
  echo "  save  - Save all GNOME settings to $SAVED_FILE"
  echo "  load  - Load all GNOME settings from $SAVED_FILE"
fi

# import Gnome desktop settings

# to save settings
#dconf dump / > dconf-settings.ini

#dconf load / < dconf-settings.ini
