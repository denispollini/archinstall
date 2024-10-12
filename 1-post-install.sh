#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Install Software"
echo "######################################################"
tput sgr0
echo
# Install software

sudo pacman -S xorg  --noconfirm --needed        
sudo pacman -S lightdm --noconfirm --needed 
sudo pacman -S lightdm-gtk-greeter --noconfirm --needed 
sudo pacman -S i3-wm --noconfirm --needed 
sudo pacman -S i3lock --noconfirm --needed 
sudo pacman -S i3status --noconfirm --needed
sudo pacman -S i3blocks --noconfirm --needed
sudo pacman -S dmenu --noconfirm --needed
sudo pacman -S terminator --noconfirm --needed
sudo pacman -S nitrogen --noconfirm --needed
sudo pacman -S materia-gtk-theme --noconfirm --needed
sudo pacman -S papirus-icon-theme --noconfirm --needed
sudo pacman -S thunar --noconfirm --needed
sudo pacman -S git --noconfirm --needed
sudo pacman -S feh --noconfirm --needed
sudo pacman -S lxappearance --noconfirm --needed
sudo pacman -S lxappearance --noconfirm --needed
sudo pacman -S ttf-font-awesome --noconfirm --needed
sudo pacman -S fonts-font-awesome --noconfirm --needed
sudo pacman -S ttf-ubuntu-font-family --noconfirm --needed
sudo pacman -S picom --noconfirm --needed
sudo pacman -S ttf-droid --noconfirm --needed
sudo pacman -S pacman-contrib --noconfirm --needed
sudo pacman -S pulseaudio-alsa --noconfirm --needed     
sudo pacman -S pulseaudio-bluetooth --noconfirm --needed
sudo pacman -S pulseaudio-equalizer --noconfirm --needed
sudo pacman -S pulseaudio-jack --noconfirm --needed
sudo pacman -S alsa-utils --noconfirm --needed
sudo pacman -S playerctl --noconfirm --needed




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

yay -S brave-bin --noconfirm

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