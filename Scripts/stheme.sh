#!/bin/bash
# This Bash Script is a quick way to switch between starship prompt configurations

# ANSI style codes
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[1;30m'
ORANGE='\033[0;33m'
WHITE='\033[1;37m'

BOLD='\x1B[1m'
ITALIC='\x1B[3m'

RESET='\033[0m\x1B[0m'

# The Script's Directory
DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# This function checks if starship is installed and configured correctly
check() {
  local LINE="eval \"\$(starship init ${SHELL##*/})\""

  # check if starship is installed
  if [[ $(which starship) ]]; then
    sleep 0
  else
    echo -e "${RED}Starship not installed, please install it"
    read -pr "press any key..."
    exit 127
  fi
  
  # Find the location of the shell config
  case $SHELL in 
      */bash)  SHELL_CONFIG="${HOME}/.bashrc" ;;
      */zsh)  SHELL_CONFIG='$HOME/.zshrc' ;;
      */fish)  SHELL_CONFIG='$HOME/.config/fish/config.fish' ;;
      */dash)   SHELL_CONFIG='$HOME/.profile' ;;
      *) 
        echo -e "$RED Your Shell is not supported $RESET"
        echo -e "$YELLOW Please use bash, zsh, fish or dash $RESET"
        exit ;;
  esac

  # Check if starship prompt is enabled in $SHELL_CONFIG
  if grep -q "$LINE" "$SHELL_CONFIG" ; then
    sleep 0
  else
    echo -e "${RED}Starship isn't Setup Properly.${RESET}"
    echo -e "${YELLOW}Please Add :" ; echo "${LINE}"
    echo -e "To the end of ${SHELL_CONFIG} ${RESET}."
    xdg-open $SHELL_CONFIG
    exit 1
  fi
}

# the main function that handles user input
main() {
  # run the check() function
  check

  # set running mode
  local MODE="$1"
  local VALUE="$2"

  if [[ ! "$MODE" ]] ; then
    sleep 0
  else
    if [[ "$MODE" == "-h" ]] ; then
      print_help
      exit 0
    elif [[ "$MODE" == "-p" ]] ; then
      set_theme_preset "$VALUE"
      exit 0
    elif [[ "$MODE" == "-c" ]] ; then
      set_theme_custom "$VALUE"
      exit 0
    elif [[ "$MODE" == "-b" ]] ; then
      backup_config "$VALUE"
      exit 0
    else 
      echo -e "$RED invalid argument $RESET"
      print_help
      exit 1
    fi
  fi
  
  # list available options
  echo -e "Stheme - Theme Switcher"
  echo "====================================="

  echo -e "${YELLOW}[${GREEN}1${YELLOW}] ${RESET} Presets"
  echo -e "${YELLOW}[${GREEN}2${YELLOW}] ${RESET} Custom"
  echo -e "${YELLOW}[${GREEN}3${YELLOW}] ${RESET} Backup"
  echo -e "${YELLOW}[${GREEN}99${YELLOW}] ${RESET} exit"


  read -rp "Choose Option: " OPTION

  case "$OPTION" in
    1|p*|P*) list_presets ;;
    2|c*|C*) list_custom ;;
    3|b*|B*) backup_config ;;
    *) exit 0 ;;
  esac
}

# CUSTOM CONFIGS

# The Directory Containing The Custom Configs (e.g. myconfig.toml)
DIR_CUSTOM="${HOME}/.config/Starship"
mapfile -t CONFIGS < <(find "$DIR_CUSTOM" -type f \( -name '*.toml' \))

# The function that lists and previews the availabel config files
list_custom() {
  if [[ ! -d $DIR_CUSTOM ]]; then
    mkdir -p $DIR_CUSTOM
    echo -e "${RED} A directory hav been created: ${DIR_CUSTOM}${RESET}"
    echo -e "${YELLOW} Please copy your custom configs to the directory. ${RESET}"
    exit
  elif [ -z "$(ls -1 "${DIR_CUSTOM}"/*.{toml} 2>/dev/null)" ] ;then
    echo -e "${RED} No configs have been found in ${DIR_CUSTOM}${RESET}"
    echo -e "${YELLOW} Please copy your custom configs to the directory${RESET}"
    exit
  else
    sleep 0
  fi

  echo -e "${GREEN}Those are all the presets of starship"
  echo "====================================="
  
  CONFIG_BAK=$STARSHIP_CONFIG
  
  for i in ${!CONFIGS[@]}; do
    echo -e "${YELLOW}[${GREEN}$((i + 1))${YELLOW}]${RESET} ${CONFIGS[i]}"
    export STARSHIP_CONFIG=${CONFIGS[i]}
    starship prompt --path "${DIR}/preview" | sed -E 's/\\(\[|\]|x1b\[[0-9;]*m)//g'
    echo ""
  done

  STARSHIP_CONFIG=$CONFIG_BAK

  # Asks The User To Choose a Theme
  echo "====================================="
  echo -e "Please Choose a Theme ${YELLOW}[${GREEN}1-${#CONFIGS[@]}${YELLOW}]${GRAY}"
  echo -e "${YELLOW}"
  read -rp " >>> " CHOICE
  echo -e "${RESET}"

  set_theme_custom "$CHOICE"
  exit
}

# the function that sets the chosen config
set_theme_custom() {
  local NUM=$1
  local CONFIG=${CONFIGS[$((NUM-1))]}
  if [[ -f "$CONFIG" ]]; then
    backup_config "$HOME/Backup/Starship/Backup_Starship $(date '+%Y-%m-%d|%H:%M:%S').toml"
    cp "$CONFIG" "$HOME/.config/starship.toml"
  else
    echo -e "$RED Selected Option Not Found.$RESET"
    clear
    list_custom
    exit
  fi
  exit 0
}


# PRESET CONFIGS

# A list of all the default presets
PRESETS=("bracketed-segments" "gruvbox-rainbow" "jetpack" "nerd-font-symbols" "no-empty-icons" "no-nerd-font" "no-runtime-versions" "pastel-powerline" "plain-text-symbols" "pure-preset" "tokyo-night")

# The function that lists and previews the availabel presets
list_presets() {
  sleep 0
}

# the function that sets the chosen preset
set_theme_preset() {
  sleep 0
  exit 0
}

# EXTRA OPTIONS
# print help message
print_help() {
  echo -e " stheme - a bash script to quickly swap starship.rs configurations"
  echo -e " --------------------------- "
  echo -e " run 'stheme' for an interactive theme switcher."
  echo " "
  echo -e " or use the avialable arguments/options."
  echo -e " --------------------------- "
  echo -e "       -h -help             | Print this message."
  echo -e "       -p -preset [number]  | apply one of the default presets."
  echo -e "       -c -custom [number]  | apply one of the custom configs in: $DIR_CUSTOM"
  echo -e "       -b -backup [path]    | backup the current configuration."
  echo -e " PS: only one option can be specified at a time"
  exit 0
}

# backup current config
backup_config() {
  sleep 0
  exit 0
}

ARG1="$1"
ARG2="$2"

main $ARG1 $ARG2


















# old code

##!/bin/bash
## this is a script to set the starship theme (Starship is a tool that lets you make your terminal prompt.)
#
## Colors For Using in The echo Commands
#RED='\033[0;31m'
#GREEN='\033[0;32m'
#GRAY='\033[0;37m'
#YELLOW='\033[1;33m'
#
#DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
#
#DIR_CUSTOM="${HOME}/Starship"
#
#case $SHELL in 
#    */bash)  SHELL_CONFIG="${HOME}/.bashrc" ;;
#    */zsh)  SHELL_CONFIG='$HOME/.zshrc' ;;
#    */fish)  SHELL_CONFIG='$HOME/.config/fish/config.fish' ;;
#    */dash)   SHELL_CONFIG='$HOME/.profile' ;;
#    *) SHELL_CONFIG='NO' ;;
#esac
#
## this is the section that handel custom themes
#set_theme_custom() {
#  local NUM=$1
#  local CONFIG=${CONFIGS[$((NUM-1))]}
#  local LINE="eval \"\$(starship init ${SHELL##*/})\""
#  cp "$CONFIG" "$HOME/.config/starship.toml"
#  if [[ $SHELL_CONFIG == "NO" ]] ;then
#    exit
#  elif grep -q "$LINE" "$SHELL_CONFIG" ;then
#    exit
#  else 
#    echo -e "${RED}Starship isn't Setup Properly.${RESET}"
#    echo -e "${YELLOW}Please Add :" ; echo "${LINE}"
#    echo -e "To the end of ${SHELL_CONFIG} ${RESET}."
#    xdg-open $SHELL_CONFIG
#  fi
#}
#
#list_custom() {
#  if [[ -d $DIR_CUSTOM ]]; then
#    mkdir -p $DIR_CUSTOM
#
#  elif [ -z "$(ls -1 "${DIR_CUSTOM}"/*.{toml} 2>/dev/null)" ] ;then
#    echo -e "${RED} No configs have been found in ${DIR_CUSTOM}${RESET}"
#    echo -e "${YELLOW} Please copy your custom configs to the directory${RESET}"
#    exit
#  else
#    mkdir -p $DIR_CUSTOM
#    echo -e "${RED} A directory hav been created: ${DIR_CUSTOM}${RESET}"
#    echo -e "${YELLOW} Please copy your custom configs to the directory${RESET}"
#    exit
#  fi
#  mapfile -t CONFIGS < <(find "$DIR_CUSTOM" -type f \( -name '*.toml' \))
#
#  echo -e "${GREEN}Those are all the presets of starship"
#  echo "====================================="
#  CONFIG_BAK=$STARSHIP_CONFIG
#  for i in ${!CONFIGS[@]}; do
#    echo -e "${YELLOW}[${GREEN}$((i + 1))${YELLOW}]${RESET} ${CONFIGS[i]}"
#    export STARSHIP_CONFIG=${CONFIGS[i]}
#    starship prompt --path "${DIR}/preview" | sed -E 's/\\(\[|\]|x1b\[[0-9;]*m)//g'
#    echo ""
#  done
#  STARSHIP_CONFIG=$CONFIG_BAK
#  # Asks The User To Choose a Theme
#  echo "====================================="
#  echo -e "Please Choose a Theme ${YELLOW}[${GREEN}1-${#CONFIGS[@]}${YELLOW}]${GRAY}"
#  echo -e "${YELLOW}"
#  read -rp " >>> " CHOICE
#  echo -e "${GRAY}"
#
#  set_theme_custom $CHOICE
#}
#
## This is the section that handels the presets
#PRESETS=("bracketed-segments" "gruvbox-rainbow" "jetpack" "nerd-font-symbols" "no-empty-icons" "no-nerd-font" "no-runtime-versions" "pastel-powerline" "plain-text-symbols" "pure-preset" "tokyo-night")
#
#set_theme_preset() {
#    local NUM=$1
#    local PRESET=${PRESETS[$((NUM-1))]}
#    starship preset ${PRESET} -o ~/.config/starship.toml
#    if [[ $SHELL_CONFIG == "NO" ]] ;then
#      exit
#    elif grep -q 'eval "$(starship init' $SHELL_CONFIG ;then
#      exit
#    else 
#      echo -e "${RED}Starship isn't Setup Properly.${RESET}"
#      echo -e "${YELLOW}Please Add :" ; echo 'eval "$(starship init)"'
#      echo -e "To the end of ${SHELL_CONFIG} ${RESET}."
#      xdg-open $SHELL_CONFIG
#    fi
#}
#
#list_presets() {
#  echo -e "${GREEN}Those are all the presets of starship"
#  echo "====================================="
#  
#  mv ~/.config/starship.toml ~/.config/starship.toml.bak
#  for i in ${!PRESETS[@]}; do
#    echo -e "${YELLOW}[${GREEN}$((i+1))${YELLOW}]${GRAY} ${PRESETS[i]}:"
#    starship preset ${PRESETS[i]} -o ~/.config/starship.toml 
#    starship prompt --path "${DIR}/preview" | sed -E 's/\\(\[|\]|x1b\[[0-9;]*m)//g'
#    echo ""
#  done
#  mv ~/.config/starship.toml.bak ~/.config/starship.toml
#
#  # Asks The User To Choose a Theme
#  echo "====================================="
#  echo -e "Please Choose a Theme ${YELLOW}[${GREEN}1-${#PRESETS[@]}${YELLOW}]${GRAY}"
#  echo -e "${YELLOW}"
#  read -rp " >>> " CHOICE
#  echo -e "${GRAY}"
#
#  # validate CHOICE
#  if ! [[ "$CHOICE" =~ ^[0-9]+$ && "$CHOICE" < 9 ]]; then
#    clear
#    echo -e "${RED}Please enter a valid number.${GRAY}"
#    list_presets
#    exit
#  else
#    set_theme_preset "$CHOICE"
#  fi
#}   
#
#if [[ $(which starship) ]];then
#  echo -e "Starship Themes -- Welcome"
#  echo "====================================="
#
#  echo -e "What Type of Theme You want to use"
#  echo -e "${YELLOW}[${GREEN}1${YELLOW}] ${RESET} Presets"
#  echo -e "${YELLOW}[${GREEN}2${YELLOW}] ${RESET} Custom"
#
#  read -rp "Choose (1/2)" ACTION
#  case "$ACTION" in
#    1|p*|P*) list_presets ;;
#    *) list_custom ;;
#  esac
#else
#  echo -e "${RED} Starship not installed. please install it to use this script.${RESET}"
#  echo ""
#  read -rp "Do you want to open a guide to install Starship? (y/n)" ACTION
#  case "$ACTION" in 
#    y|Y|yes|"") xdg-open "https://starship.rs" ;;
#    *) exit ;;
#  esac
#fi

