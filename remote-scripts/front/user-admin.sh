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
    printf "${menu}**${number} 1)${menu} Add / Delete user ${normal}\n"
    printf "${menu}**${number} 2)${menu} Reset user password ${normal}\n"
    printf "${menu}**${number} 3)${menu} Give user sudo rights ${normal}\n"
    printf "${menu}**${number} 4)${menu} Allow user to run some sudo commands ${normal}\n"
    printf "${menu}**${number} 5)${menu} Some other commands${normal}\n"
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
            option_picked "Option 1 Picked: Add / Delete user";
            $REMOTE_PATH/back/add-user.sh;
            show_menu;
        ;;
        2) clear;
            option_picked "Option 2 Picked: Reset user password";
            $REMOTE_PATH/back/reset-password.sh;
            show_menu;
        ;;
        3) clear;
            option_picked "Option 3 Picked: Give user sudo rights";
            $REMOTE_PATH/back/sudo-rights.sh;
            show_menu;
        ;;
        4) clear;
            option_picked "Option 4 Picked: Allow user to run some sudo commands";
            $REMOTE_PATH/back/allow-sudo-commands.sh;
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
