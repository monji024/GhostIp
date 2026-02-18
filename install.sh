#!/bin/bash
# author : Monji
# GitHub : https://github.com/monji024


GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}+ Checking dependencies...${NC}"

if ! command -v ruby &> /dev/null; then
    echo -e "${RED}+ Ruby not found. Installing...${NC}"
    sudo apt update
    sudo apt install ruby -y
    echo -e "${GREEN}! Ruby installed${NC}"
else
    echo -e "${GREEN}✓ Ruby already installed${NC}"
fi

if ! command -v tor &> /dev/null; then
    echo -e "${RED}+ Tor not found Installing...${NC}"
    sudo apt update
    sudo apt install tor -y
    echo -e "${GREEN}! Tor installed${NC}"
else
    echo -e "${GREEN}✓ Tor already installed${NC}"
fi

if ! gem list -i socksify &> /dev/null; then
    echo -e "${RED}+ socksify gem not found. Installing...${NC}"
    sudo gem install socksify
    echo -e "${GREEN}! socksify installed${NC}"
else
    echo -e "${GREEN}✓ socksify gem already installed${NC}"
fi
