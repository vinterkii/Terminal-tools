#!/bin/bash
# a Wallpaper changer script 

# ANSI Colors Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Change This Value to change the Wallpaper Directory
DIR_WALLPAPERS="$HOME/.config/Wallpapers"

# The Final Function set the first passed file path as the desktop wallpaper
set_wallpaper() {
  local FILE="$1"
  
  # Check if file exists (Paranoia)
  if [[ ! -s "${FILE}" ]]; then
    echo -e "${RED} File is Empty or Deleted. ${RESET}"
    exit
  else # these three lines are the final goal of this entire script... >:(
    gsettings set org.gnome.desktop.screensaver picture-uri "file://${FILE}" && echo -e "${GREEN} Set Lock Screen Wallpaper. ${RESET}"
    gsettings set org.gnome.desktop.background picture-uri "file://${FILE}" && echo -e "${GREEN} Set Light Wallpaper. ${RESET}"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://${FILE}" && echo -e "${GREEN} Set Dark Wallpaper. ${RESET}"
    exit 
  fi
}

choose_wallpaper() {
  local NUM
  local COUNT=${#WALLPAPERS[@]}
  
  # Write all the available wallpapers
  for i in "${!WALLPAPERS[@]}"; do
    echo -e "${YELLOW}[${GREEN}$((i+1))${YELLOW}] ${RESET} ${WALLPAPERS[i]#"$DIR_WALLPAPERS"}"
  done
  
  # Asks The User To Choose a Wallpaper
  echo -e "Please Choose a Wallpaper ${YELLOW}[${GREEN}1-${COUNT}${YELLOW}]${RESET}"
  echo -e "${YELLOW}"
  read -rp " >>> " NUM
  echo -e "${RESET}"
  
  # validate NUM
  if ! [[ "$NUM" =~ ^[0-9]+$ && "$NUM" < "(($COUNT+1))" ]]; then
    echo -e "${RED}Please enter a valid number.${RESET}"
    choose_wallpaper
    exit
  else
    WALLPAPER="${WALLPAPERS[$((NUM-1))]}"
    confirm "$WALLPAPER"
  fi
}

# Confirm Wallpaper choice
confirm() {
  local SELECT="$1"
  
  if which kitten ;then
    kitten icat $SELECT
  else
    xdg-open "$SELECT"
  fi
  read -rp "Are You Sure You Want to Apply (y/n)?" ACTION
  case "$ACTION" in 
    y|Y|yes|"")
      set_wallpaper "$SELECT"
      exit ;;
    *)
      clear
      choose_wallpaper
      exit ;;
  esac
}

# Check if the wallpaper directory exists
if [[ ! -d "${DIR_WALLPAPERS}" ]];then 
  # And Creates it if it doesn't exist
  mkdir -p "${DIR_WALLPAPERS}"
  echo -e "${RED}No Wallpaper Directory is Found${RESET}" 
  echo -e "The Directory has been created at ${YELLOW}${DIR_WALLPAPERS}${RESET}" 
  exit
elif [ -z "$(ls -1 "${DIR_WALLPAPERS}"/*.{png,jpg,jpeg,gif} 2>/dev/null)" ]; then
  echo -e "${RED}No Wallpapers Found${RESET}"
  echo -e "${YELLOW}Please copy your wallpapers to ${DIR_WALLPAPERS}${RESET}"
  exit
else
  # Or puts all the files in directory in an array named "WALLPAPERS" 
  mapfile -t WALLPAPERS < <(find "$DIR_WALLPAPERS" -maxdepth 1 -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.gif' \))
  choose_wallpaper
fi
