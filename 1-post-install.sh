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

sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo
tput setaf 3
echo "######################################################"
echo "################### Install Software"
echo "######################################################"
tput sgr0
echo
# Install software

sudo pacman -S terminator  --noconfirm --needed        
sudo pacman -S nano --noconfirm --needed 
sudo pacman -S vim --noconfirm --needed 
sudo pacman -S xorg-xinit --noconfirm --needed 
sudo pacman -S lightdm --noconfirm --needed 
sudo pacman -S lightdm-gtk-greeter --noconfirm --needed
sudo pacman -S i3 --noconfirm --needed
sudo pacman -S feh --noconfirm --needed
sudo pacman -S thunderbird --noconfirm --needed
sudo pacman -S nitrogen --noconfirm --needed
sudo pacman -S materia-gtk-theme --noconfirm --needed
sudo pacman -S papirus-icon-theme --noconfirm --needed

echo
tput setaf 3
echo "######################################################"
echo "################### Install AUR Software"
echo "######################################################"
tput sgr0
echo
# Install AUR Software

yay -S brave-bin --noconfirm