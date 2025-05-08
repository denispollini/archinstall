#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Gnome."
echo "######################################################"
tput sgr0
echo
#Restore Config Gnome
cat /$HOME/Nextcloud/backup-config/dconf-settings.ini | dconf load /

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Brave."
echo "######################################################"
tput sgr0
echo
#Restore Config Brave
cp -r /$HOME/Nextcloud/backup-config/.config/BraveSoftware /$HOME/.config/ 


echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Thunderbird."
echo "######################################################"
tput sgr0
echo
#Restore Config Thunderbird
cp -r /$HOME/Nextcloud/backup-config/.thunderbird /$HOME/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Cryptomator."
echo "######################################################"
tput sgr0
echo
#Restore Config Cryptomator
cp -r /$HOME/Nextcloud/backup-config/.config/Cryptomator /$HOME/.config/ 
cp -r /$HOME/Nextcloud/backup-config/.local/share/Cryptomator /$HOME/.local/share/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config KeepassXC."
echo "######################################################"
tput sgr0
echo
#Restore Config KeepassXC
cp -r /$HOME/Nextcloud/backup-config/.config/keepassxc /$HOME/.config/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Insync."
echo "######################################################"
tput sgr0
echo
#Restore Config Insync
cp -r /$HOME/Nextcloud/backup-config/.config/Insync /$HOME/.config/ 
cp -r /$HOME/Nextcloud/backup-config/.local/share/Insync /$HOME/.local/share/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Nextcloud."
echo "######################################################"
tput sgr0
echo
#Restore Config Nextcloud
cp -r /$HOME/Nextcloud/backup-config/.config/Nextcloud /$HOME/.config/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config RustDesk."
echo "######################################################"
tput sgr0
echo
#Restore Config RustDesk
cp -r /$HOME/Nextcloud/backup-config/.config/rustdesk /$HOME/.config/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config WinBOX."
echo "######################################################"
tput sgr0
echo
#Restore Config WinBOX
cp -r /$HOME/Nextcloud/backup-config/.local/share/MikroTik /$HOME/.local/share/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Remmina."
echo "######################################################"
tput sgr0
echo
#Restore Config Remmina
cp -r /$HOME/Nextcloud/backup-config/.local/share/remmina /$HOME/.local/share/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Config Zed."
echo "######################################################"
tput sgr0
echo
#Restore Config Zed
cp -r /$HOME/Nextcloud/backup-config/.local/share/zed /$HOME/.local/share/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore GNOME Shell."
echo "######################################################"
tput sgr0
echo
#Restore GNOME Shell
cp -r /$HOME/Nextcloud/backup-config/.local/share/gnome-shell /$HOME/.local/share/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Bash Config."
echo "######################################################"
tput sgr0
echo
#Restore Bash Config
cp -r /$HOME/Nextcloud/backup-config/.bashrc /$HOME/ 
cp -r /$HOME/Nextcloud/backup-config/.bashrc-personal /$HOME/ 

echo
tput setaf 3
echo "######################################################"
echo "################### Restore Fish Config."
echo "######################################################"
tput sgr0
echo
#Backup Fish Config
cp -r /$HOME/Nextcloud/backup-config/.config/fish /$HOME/.config/ 
