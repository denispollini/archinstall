#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### VirtualBOX"
echo "######################################################"
tput sgr0
echo
# VirtualBOX

sudo pacman -S virtualbox-guest-utils --noconfirm --needed

echo
tput setaf 3
echo "######################################################"
echo "################### Enable Services"
echo "######################################################"
tput sgr0
echo
# Enable Services


sudo systemctl enable vboxservice
sudo systemctl start vboxservice
