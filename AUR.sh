#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Install Yay"
echo "######################################################"
tput sgr0
echo
# Install Yay

cd /home/$USER/
git clone https://aur.archlinux.org/yay.git
cd yay
sudo makepkg -si --noconfirm

echo
tput setaf 3
echo "######################################################"
echo "################### Install AUR Software"
echo "######################################################"
tput sgr0
echo
# Install AUR Software

yay -S brave-bin --noconfirm
yay -S bibata-cursor-theme --noconfirm