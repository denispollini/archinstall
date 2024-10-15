#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Install DE Cinnamon"
echo "######################################################"
tput sgr0
echo
# Install DE Cinnamon

sudo pacman -S xorg  --noconfirm --needed
sudo pacman -S cinnamon  --noconfirm --needed         
sudo pacman -S lightdm --noconfirm --needed 
sudo pacman -S lightdm-gtk-greeter --noconfirm --needed 
sudo pacman -S terminator --noconfirm --needed
sudo pacman -S materia-gtk-theme --noconfirm --needed
sudo pacman -S papirus-icon-theme --noconfirm --needed

echo
tput setaf 3
echo "######################################################"
echo "################### Install Yay"
echo "######################################################"
tput sgr0
echo
# Install Yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo
tput setaf 3
echo "######################################################"
echo "################### Install AUR Software"
echo "######################################################"
tput sgr0
echo
# Install AUR Software

#yay -S brave-bin --noconfirm

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