#!/bin/bash
# this is a script that turns the scripts in 'Scripts' into shell commands

# ANSI Color & Style
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'

BOLD='\x1B[1m'
ITALIC='\x1B[3m'

RESET='\033[0m\x1B[0m'

# Geting the Terminal-tools Directory
DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Get The Path to the used shell configuration
case $SHELL in 
    */bash)  SHELL_CONFIG="${HOME}/.bashrc" ;;
    */zsh)  SHELL_CONFIG='$HOME/.zshrc' ;;
    */fish)  SHELL_CONFIG='$HOME/.config/fish/config.fish' ;;
    */dash)   SHELL_CONFIG='$HOME/.profile' ;;
    # Support for more shells can be added by just adding more cases 
    *) 
        echo -e "${RED} Sorry Your Shell is not supported yet...${RESET}" 
        echo -e "${YELLOW} Please Use (Bash, Zsh, Fish or dash)${RESET}" 
        read -pr "Press Any Key..."
        exit ;;
esac

# the backup function runs before every function that changes the Shell Config
backup_config() {
    # Set Backup Date & Time
    local date
    date="$(date '+%Y-%m-%d|%H:%M:%S')"

    # Set Backup Path
    if grep -qi 'tails' /etc/os-release ;then
        if [[ -d "/live/persistence/TailsData_unlocked/dotfiles/Backup/Shell_Config" ]] ;then
            SHELL_CONFIG_BACKUP="/live/persistence/TailsData_unlocked/dotfiles/Backup/Shell_Config/${SHELL##/*/}_${date}_Backup.txt"
        else # if the Persistent Backup folder Hasn't been setup use the normal folder and the user will be prompted later to set it up
            SHELL_CONFIG_BACKUP="$HOME/Backup/Shell_Config/${SHELL##/*/}_${date}_Backup.txt"
        fi
    else # If not using tailsOS just continue as normal
        SHELL_CONFIG_BACKUP="$HOME/Backup/Shell_Config/${SHELL##/*/}_${date}_Backup.txt"
    fi
    # Make the Backup Directory
    mkdir -p "$HOME/Backup/Shell_Config"
    # Make a backup
    cat "$SHELL_CONFIG" >> "$SHELL_CONFIG_BACKUP"
    echo -e "${YELLOW}Your '$SHELL_CONFIG' Have been backed up in to '$SHELL_CONFIG_BACKUP' ${RESET}"
    return
}

# The install function
install() { #This function can't use indentation becuse Bash Scripting Sucks

# Backups For Safety
backup_config

cat >> "$SHELL_CONFIG" <<EOF # Apends thee Following text to SHELL_CONFIG
# Terminal-tools setup MlVkT0a3
alias wall='bash ${DIR}/Scripts/wall.sh'

alias stheme='bash ${DIR}/Scripts/stheme.sh'
# End Of Terminal-tools (PS: Don't Add any thing inside it will be replaced when reinstalling)

EOF
echo -e "${GREEN}Done.${RESET} Terminal-tools is now installed"
refresh
return
}

# The remove function
uninstall() {
    local start_marker="# Terminal-tools setup MlVkT0a3"
    local end_marker="# End Of Terminal-tools"
    
    # Rechecks if setup.sh has run before
    if grep -qF "$start_marker" "$SHELL_CONFIG"; then
        backup_config
            
        if readlink $SHELL_CONFIG ;then
            local SHELL_CONFIG_TAILSOS
            SHELL_CONFIG_TAILSOS=$(readlink $SHELL_CONFIG)
            # remove every line that lies between the start_marker and end_marker
            sed -i "/$start_marker/,/$end_marker/d" "$SHELL_CONFIG_TAILSOS"
            echo -e "${GREEN}Done.${RESET} Tails tools have been removed."
        else
            # remove every line that lies between the start_marker and end_marker
            sed -i "/$start_marker/,/$end_marker/d" "$SHELL_CONFIG"
            echo -e "${GREEN}Done.${RESET} Tails tools have been removed."
        fi
    else # This Probebly Wont be the case ever (Unless somthing changes while the script is running)
        echo -e "${RED}Terminal-tools isn't installed or have been messed with.${RESET}"
        echo -e "Automatic removal is not available"
    fi
    refresh
    return
}

# Update function using git
update() {
    if which git;then
        if [[ -d ".git" ]]; then
            git pull origin main
        else
            git init
            git remote set-url origin https://github.com/vinterkii/Terminal-tools
            git pull origin main
        fi
        echo -e "${YELLOW}Please Run the setup agian and select 'reinstall'${RESET}"
        return
    else
        echo -e "${RED}Git is not installed.... somehow???"
        return
    fi 
}

reinstall() {
    echo -e "${YELLOW}Terminal-tools will be reinstalled soon..."
    uninstall
    sleep .5
    install
    echo -e "${GREEN}Done.${RESET} Terminal-tools has been re installed"
    refresh
    return
}

# this function lets the changes to SHELL_CONFIG apply to the current terminal without restaritng it
refresh() {
    case "$SHELL" in
        */bash) source ${HOME}/.bashrc ;;
        */zsh) source $HOME/.zshrc ;;
        */fish) source $HOME/.config/fish/config.fish ;;
        */dash)  . $HOME/.profile ;;
        *) echo -e "${YELLOW}Please restart your terminal to apply changes..${RESET}" ;;
    esac
    return
}

# Check if the setup has run before
if grep -q "# Terminal-tools setup MlVkT0a3" $SHELL_CONFIG ; then
    echo -e "The Script Has been Setup Before..."
    # Choices
    echo -e "What do you want to do:"
    echo -e "${YELLOW} 1. ${RESET}reinstall"
    echo -e "${YELLOW} 2. ${RESET}update"
    echo -e "${YELLOW} 3. ${RESET}uninstall"
    read -p "Please Choose an action: " ACTION
    case $ACTION in
        1|reinstall) reinstall;;
        2|update) update && echo -e "${YELLOW}Please Run the setup agian and select 'reinstall'${RESET}";;
        3|remove) uninstall;;
        *) refresh ;;
    esac
else
    echo -e "The script will modify your ${SHELL_CONFIG}"
    read -rp "..." 
    echo -e "The script will add these aliases:"
    echo "${ORANGE}wall ${GRAY}# This is the Wallpaper Changer for Gnome"
    echo "${ORANGE}stheme ${GRAY}# This is a Starship.rs Theme Switcher"
    # add more aliases as you add more scripts  
    
    read -p "Are You Sure You Want To Continue? (y/n):" ACTION
    case "$ACTION" in 
        y|Y|yes) install ;;
        n|N|No|*) exit ;;
    esac
fi

# This will only run on tails Devices 
# ask wether to move the current Shell Config and backups to the dotfiles directory 
if grep -qi 'tails' /etc/os-release; then

  dest="/live/persistence/TailsData_unlocked/dotfiles/${SHELL_CONFIG#'/home/amnesia/'}"

  if [[ ! -f "$dest" ]]; then
    echo -e "${PURPLE}TailsOS: ${RESET}Your ${SHELL_CONFIG#'/home/amnesia/'} and it's backups will be reset if you restart your computer."
    check_dotfiles_tails() {
        if [[ ! -e "/live/persistence/TailsData_unlocked/dotfiles" ]] ; then
            echo -e "${RED} dotfiles feature can't be accessed"
            echo -e "${YELLOW} Please Enable it in the Persistent Storage App"
            read -p "Press Any key to Retry..."
            check_dotfiles_tails 
        else
            return
        fi
    }

    check_dotfiles_tails
    
    read -rp "Would you like to move it into persistent storage? (y/n):" ACTION

    case "$ACTION" in
      y|Y|yes|"")
        cp "$SHELL_CONFIG" "$dest"

        mkdir -p "/live/persistence/TailsData_unlocked/dotfiles/Backup/Shell_Config"
        cp -r "$HOME/Backup/Shell_Config" "/live/persistence/TailsData_unlocked/dotfiles/Backup/Shell_Config"

        echo -e "${GREEN}Done. ${RESET} Your ${SHELL_CONFIG} is now Persistent"
        exit
        ;;
      *)
        exit
        ;;
    esac
  else
    exit
  fi
fi



