#!/bin/bash
# this is a script to set the starship theme (Starship is a tool that lets you make your terminal prompt.)

# Colors For Using in The echo Commands
RED='\033[0;31m'
GREEN='\033[0;32m'
GRAY='\033[0;37m'
YELLOW='\033[1;33m'

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DIR_CUSTOM="/home/Starship"

case $SHELL in 
    */bash)  SHELL_CONFIG="${HOME}/.bashrc" ;;
    */zsh)  SHELL_CONFIG='$HOME/.zshrc' ;;
    */fish)  SHELL_CONFIG='$HOME/.config/fish/config.fish' ;;
    */dash)   SHELL_CONFIG='$HOME/.profile' ;;
    *) SHELL_CONFIG='NO' ;;
esac

# this is the section that handel custom themes
set_theme_custom() {
 echo "i"
}

list_custom() {
  mapfile -t WALLPAPERS < <(find "$DIR_CUSTOM" -maxdepth 1 -type f \( -name '*.toml' \))
}

# This is the section that handels the presets
PRESETS=("bracketed-segments" "gruvbox-rainbow" "jetpack" "nerd-font-symbols" "no-empty-icons" "no-nerd-font" "no-runtime-versions" "pastel-powerline" "plain-text-symbols" "pure-preset" "tokyo-night")

set_theme_preset() {
    local NUM=$1
    local PRESET=${PRESETS[$((NUM-1))]}
    starship preset ${PRESET} -o ~/.config/starship.toml
    if [[ $SHELL_CONFIG == "NO" ]] ;then
      exit
    elif grep -q 'eval "$(starship init' $SHELL_CONFIG ;then
      exit
    else 
      echo -e "${RED}Starship isn't Setup Properly.${RESET}"
      echo -e "${YELLOW}Please Add :" ; echo 'eval "$(starship init)"'
      echo -e "To the end of ${SHELL_CONFIG} ${RESET}."
      xdg-open $SHELL_CONFIG
    fi
}

list_presets() {
  echo -e "${GREEN}Those are all the presets of starship"
  echo "====================================="
  
  mv ~/.config/starship.toml ~/.config/starship.toml.bak
    for i in ${!PRESETS[@]}; do
        echo -e "${YELLOW}[${GREEN}$((i+1))${YELLOW}]${GRAY} ${PRESETS[i]}:"
        starship preset ${PRESETS[i]} -o ~/.config/starship.toml 
        starship prompt --path "${DIR}/preview" | sed -E 's/\\(\[|\]|x1b\[[0-9;]*m)//g'
        echo ""
    done
  mv mv ~/.config/starship.toml.bak ~/.config/starship.toml
  
    # Asks The User To Choose a Theme
    echo "====================================="
    echo -e "Please Choose a Theme ${YELLOW}[${GREEN}1-7${YELLOW}]${GRAY}"
    echo -e "${YELLOW}"
    read -rp " >>> " CHOICE
    echo -e "${GRAY}"

    # validate CHOICE
    if ! [[ "$CHOICE" =~ ^[0-9]+$ && "$CHOICE" < 9 ]]; then
      clear
      echo -e "${RED}Please enter a valid number.${GRAY}"
      list_presets
      exit
    else
      set_theme_preset "$CHOICE"
    fi
}   

if [[ $(which starship) ]];then
  echo -e "Starship Themes -- Welcome"
  echo "====================================="

  echo -e "What Type of Theme You want to use"
  echo -e "${YELLOW}[${GREEN}1${YELLOW}] ${RESET} Presets"
  echo -e "${YELLOW}[${GREEN}2${YELLOW}] ${RESET} Custom"

  read -rp "Choose (1/2)" ACTION
  case "$ACTION" in
    1|p*|P*) list_presets ;;
    *) list_custom ;;
  esac
else
  echo -e "${RED} Starship not installed. please install it to use this script.${RESET}"
  echo ""
  read -rp "Do you want to open a guide to install Starship? (y/n)" ACTION
  case "$ACTION" in 
    y|Y|yes|"") xdg-open "https://starship.rs" ;;
    *) exit ;;
  esac
fi
