#!/bin/bash
# Import/Export GNOME desktop settings
# Source the colors script
source ./colours.sh
SAVED_FILE="dconf-settings.ini"

PATHS=(
  "/org/gnome/shell/"
  "/org/gnome/desktop/"
  "/org/gnome/mutter/"
)

if [ "$1" == "save" ]; then
  > "$SAVED_FILE"  # Clear file
  for path in "${PATHS[@]}"; do
    dconf dump "$path" >> "$SAVED_FILE"
  done
  echo -e "${GREEN}Desktop settings saved to $SAVED_FILE${NC}"
elif [ "$1" == "load" ]; then
  if [ -f "$SAVED_FILE" ]; then
    for path in "${PATHS[@]}"; do
      dconf load "$path" < "$SAVED_FILE"
    done
    echo -e "${GREEN}Desktop settings loaded from $SAVED_FILE${NC}"
  else
    echo -e "${RED}No saved settings file found! Expected file: $SAVED_FILE${NC}"
  fi
else
  echo -e "${YELLOW}Usage: $0 {save|load}${NC}"
fi
