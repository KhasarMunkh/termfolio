#!/bin/bash
# Welcome script with ANSI art

# Catppuccin Macchiato colors
MAUVE='\033[38;2;198;160;246m'
BLUE='\033[38;2;138;173;244m'
TEAL='\033[38;2;139;213;202m'
GREEN='\033[38;2;166;218;149m'
YELLOW='\033[38;2;238;212;159m'
PEACH='\033[38;2;245;169;127m'
TEXT='\033[38;2;202;211;245m'
SUBTEXT='\033[38;2;165;173;203m'
RESET='\033[0m'

echo ""
echo -e "${MAUVE}  ╦╔═┬ ┬┌─┐┌─┐┌─┐┬─┐  ╔╦╗┬ ┬┌┐┌┬┌─┬ ┬${RESET}"
echo -e "${BLUE}  ╠╩╗├─┤├─┤└─┐├─┤├┬┘  ║║║│ ││││├┴┐├─┤${RESET}"
echo -e "${TEAL}  ╩ ╩┴ ┴┴ ┴└─┘┴ ┴┴└─  ╩ ╩└─┘┘└┘┴ ┴┴ ┴${RESET}"
echo ""
echo -e "${TEXT}  Software Developer${RESET}"
echo -e "${SUBTEXT}  ─────────────────────────────────────${RESET}"
echo ""
echo -e "${GREEN}  Commands:${RESET}"
echo -e "${SUBTEXT}    about     ${TEXT}- Learn about me${RESET}"
echo -e "${SUBTEXT}    projects  ${TEXT}- Browse my work${RESET}"
echo -e "${SUBTEXT}    skills    ${TEXT}- Technical skills${RESET}"
echo -e "${SUBTEXT}    contact   ${TEXT}- Get in touch${RESET}"
echo ""
echo -e "${YELLOW}  Try:${RESET} ${TEXT}cd ~/projects && nvim .${RESET}"
echo ""
