#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Install Cinnamon"
echo "######################################################"
tput sgr0
echo
# Install DE Cinnamon

sudo pacman -S xorg  --noconfirm --needed
sudo pacman -S cinnamon  --noconfirm --needed         
sudo pacman -S lightdm --noconfirm --needed 
sudo pacman -S lightdm-gtk-greeter --noconfirm --needed
sudo pacman -S lightdm-gtk-greeter-settings --noconfirm --needed
sudo pacman -S terminator --noconfirm --needed
sudo pacman -S arc-gtk-theme --noconfirm --needed
sudo pacman -S archlinux-wallpaper --noconfirm --needed
sudo pacman -S papirus-icon-theme --noconfirm --needed
sudo pacman -S fish --noconfirm --needed

echo
tput setaf 3
echo "######################################################"
echo "################### Enable Services"
echo "######################################################"
tput sgr0
echo
# Enable Services

sudo systemctl enable lightdm.service
sudo systemctl start lightdm.service