#!/bin/bash
# Import/Export GNOME desktop settings

# Source the colors script
source ./colours.sh

SAVED_FILE="dconf-settings.ini"

if [ "$1" == "save" ]; then
  # Save all GNOME settings to a file
  dconf dump / >"$SAVED_FILE"
  echo -e "${GREEN}Settings saved to $SAVED_FILE${NC}"

elif [ "$1" == "load" ]; then
  # Load all GNOME settings from a file
  if [ -f "$SAVED_FILE" ]; then
    dconf load / <"$SAVED_FILE"
    echo -e "${GREEN}Settings loaded from $SAVED_FILE${NC}"
  else
    echo -e "${RED}No saved settings file found! Expected file: $SAVED_FILE${NC}"
  fi

else
  echo -e "${YELLOW}Usage: $0 {save|load}${NC}"
  echo -e "${YELLOW}  save  - Save all GNOME settings to $SAVED_FILE${NC}"
  echo -e "${YELLOW}  load  - Load all GNOME settings from $SAVED_FILE${NC}"
fi
