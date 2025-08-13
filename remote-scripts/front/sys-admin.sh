#!/bin/sh
#
REMOTE_PATH=/c/Users/makwetjat/remote-scripts
#
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Security Patching (DNF/YUM)${normal}\n"
    printf "${menu}**${number} 2)${menu} RPM package management ${normal}\n"
    printf "${menu}**${number} 3)${menu} Restart Services ${normal}\n"
    printf "${menu}**${number} 4)${menu} Storage management (LVM & VGS) ${normal}\n"
    printf "${menu}**${number} 5)${menu} Remote sudo command${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "Option 1 Picked";
            $REMOTE_PATH/back/security-patching.sh;
            show_menu;
        ;;
        2) clear;
            option_picked "Option 2 Picked";
            $REMOTE_PATH/back/package-management.sh;
            show_menu;
        ;;
        3) clear;
            option_picked "Option 3 Picked";
            $REMOTE_PATH/back/restart-services.sh;
            show_menu;
        ;;
        4) clear;
            option_picked "Option 4 Picked";
            #$REMOTE_PATH/back/remote-sudo.sh;
            show_menu;
	;;
        5) clear;
            option_picked "Option 4 Picked";
            $REMOTE_PATH/back/remote-sudo.sh;
            show_menu;
        ;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done
