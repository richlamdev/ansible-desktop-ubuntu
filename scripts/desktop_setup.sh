#!/usr/bin/env bash
# Import / Export GNOME desktop settings safely
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colours.sh"

command -v dconf >/dev/null || {
  echo -e "${RED}dconf not installed${NC}"
  exit 1
}

SAVED_FILE="dconf-settings.ini"
SEPARATOR="### DCONF_PATH:"

PATHS=(
  "/org/gnome/shell/"
  "/org/gnome/desktop/interface/"
  "/org/gnome/desktop/peripherals/"
  "/org/gnome/desktop/wm/"
  "/org/gnome/desktop/input-sources/"
  "/org/gnome/desktop/background/"
  "/org/gnome/desktop/screensaver/"
  "/org/gnome/desktop/privacy/"
  "/org/gnome/desktop/search-providers/"
  "/org/gnome/desktop/session/"
  "/org/gnome/desktop/sound/"
  "/org/gnome/mutter/keybindings/"
  "/org/gnome/settings-daemon/"
  "/org/gnome/terminal/"
)

# Sections to exclude from the dump (noise with no restore value)
EXCLUDE_SECTIONS=(
  "notifications"
  "app-picker-layout"
)

TMP_FILE=""
TMP_SAVE=""

cleanup() {
  [[ -n "${TMP_FILE:-}" && -f "$TMP_FILE" ]] && rm -f "$TMP_FILE"
  [[ -n "${TMP_SAVE:-}" && -f "$TMP_SAVE" ]] && rm -f "$TMP_SAVE"
}

trap cleanup EXIT

########################################
# Filter out excluded sections
########################################
filter_dump() {
  local skip=false
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Check if this is a section header
    if [[ "$line" =~ ^\[.*\] ]]; then
      skip=false
      for pattern in "${EXCLUDE_SECTIONS[@]}"; do
        if [[ "$line" == *"$pattern"* ]]; then
          skip=true
          break
        fi
      done
    fi

    # Check if this is a top-level key to exclude
    if [[ "$skip" == false ]]; then
      local exclude_key=false
      for pattern in "${EXCLUDE_SECTIONS[@]}"; do
        if [[ "$line" == "${pattern}="* ]]; then
          exclude_key=true
          break
        fi
      done
      [[ "$exclude_key" == false ]] && echo "$line"
    fi
  done
}

########################################
# Save settings
########################################
do_save() {
  TMP_SAVE="$(mktemp)"

  for path in "${PATHS[@]}"; do
    dump_output="$(dconf dump "$path" | filter_dump)"

    if grep -q "=" <<< "$dump_output"; then
      echo "${SEPARATOR} ${path}" >> "$TMP_SAVE"
      echo "$dump_output" >> "$TMP_SAVE"
      echo "" >> "$TMP_SAVE"
      echo -e "${GREEN}Saved ${path}${NC}"
    else
      echo -e "${YELLOW}Skipping empty path ${path}${NC}"
    fi
  done

  mv "$TMP_SAVE" "$SAVED_FILE"
  echo -e "${GREEN}All settings saved to ${SAVED_FILE}${NC}"
}

########################################
# Load settings
########################################
do_load() {
  if [[ ! -f "$SAVED_FILE" ]]; then
    echo -e "${RED}No saved settings file found: ${SAVED_FILE}${NC}"
    exit 1
  fi

  TMP_FILE="$(mktemp)"
  current_path=""

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == "${SEPARATOR}"* ]]; then
      if [[ -n "$current_path" && -s "$TMP_FILE" ]]; then
        dconf load "$current_path" < "$TMP_FILE"
        echo -e "${GREEN}Loaded ${current_path}${NC}"
      fi
      current_path="${line#"${SEPARATOR} "}"
      current_path="${current_path%$'\r'}"
      > "$TMP_FILE"
    else
      echo "$line" >> "$TMP_FILE"
    fi
  done < "$SAVED_FILE"

  if [[ -n "$current_path" && -s "$TMP_FILE" ]]; then
    dconf load "$current_path" < "$TMP_FILE"
    echo -e "${GREEN}Loaded ${current_path}${NC}"
  fi

  echo -e "${GREEN}All settings restored from ${SAVED_FILE}${NC}"
}

########################################
# Main
########################################
case "${1:-}" in
  save)
    do_save
    ;;
  load)
    do_load
    ;;
  *)
    echo -e "${YELLOW}Usage: $0 {save|load}${NC}"
    exit 1
    ;;
esac
