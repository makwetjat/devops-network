#!/bin/bash
REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Centering function
center_text() {
    local text="$1"
    local width=$(tput cols)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s%*s\n" "$padding" "" "$text" "$padding" ""
}

clear
export REMOTE_PATH="/c/Users/makwetjat/remote-scripts"
# Print menu with colors and centering
echo -e "${BLUE}$(center_text '=============================================')${NC}"
echo -e "${YELLOW}$(center_text '      WELCOME TO AUTOMATION MAIN MENU      ')${NC}"
echo -e "${BLUE}$(center_text '=============================================')${NC}"
echo
echo -e "${GREEN}$(center_text '1) User Admin')${NC}"
echo -e "${GREEN}$(center_text '2) System Admin')${NC}"
echo -e "${GREEN}$(center_text '3) Run Remote Scripts')${NC}"
echo -e "${RED}$(center_text '4) Exit')${NC}"
echo
echo -e "${BLUE}$(center_text '=============================================')${NC}"
echo -e "${YELLOW}$(center_text '      Choices above are ran remotely      ')${NC}"
echo -e "${BLUE}$(center_text '=============================================')${NC}"
echo -e -n "${YELLOW}$(center_text 'Enter your choice: ')${NC}"
read -r CHOICE

# Handle user choice
case $CHOICE in
    1)
        echo -e "${GREEN}$(center_text 'You chose Option 1')${NC}"
	$REMOTE_PATH/front/user-admin.sh
        ;;
    2)
        echo -e "${GREEN}$(center_text 'You chose Option 2')${NC}"
	$REMOTE_PATH/front/sys-admin.sh
        ;;
    3)
        echo -e "${GREEN}$(center_text 'You chose Option 3')${NC}"
	$REMOTE_PATH/back/run-remote-script-plink.sh
        ;;
    4)
        echo -e "${RED}$(center_text 'Exiting...')${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}$(center_text 'Invalid choice!')${NC}"
        ;;
esac

