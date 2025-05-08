#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Gnome."
echo "######################################################"
tput sgr0
echo
#Backup Config Gnome
dconf dump / > /$HOME/Nextcloud/backup-config/dconf-settings.ini

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Brave."
echo "######################################################"
tput sgr0
echo
#Backup Config Brave
cp -r /$HOME/.config/BraveSoftware /$HOME/Nextcloud/backup-config/.config/


echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Thunderbird."
echo "######################################################"
tput sgr0
echo
#Backup Config Thunderbird
cp -r /$HOME/.thunderbird /$HOME/Nextcloud/backup-config/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Cryptomator."
echo "######################################################"
tput sgr0
echo
#Backup Config Cryptomator
cp -r /$HOME/.config/Cryptomator /$HOME/Nextcloud/backup-config/.config/
cp -r /$HOME/.local/share/Cryptomator /$HOME/Nextcloud/backup-config/.local/share/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config KeepassXC."
echo "######################################################"
tput sgr0
echo
#Backup Config KeepassXC
cp -r /$HOME/.config/keepassxc /$HOME/Nextcloud/backup-config/.config/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Insync."
echo "######################################################"
tput sgr0
echo
#Backup Config Insync
cp -r /$HOME/.config/Insync /$HOME/Nextcloud/backup-config/.config/
cp -r /$HOME/.local/share/Insync /$HOME/Nextcloud/backup-config/.local/share/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Nextcloud."
echo "######################################################"
tput sgr0
echo
#Backup Config Nextcloud
cp -r /$HOME/.config/Nextcloud /$HOME/Nextcloud/backup-config/.config/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config RustDesk."
echo "######################################################"
tput sgr0
echo
#Backup Config RustDesk
cp -r /$HOME/.config/rustdesk /$HOME/Nextcloud/backup-config/.config/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config WinBOX."
echo "######################################################"
tput sgr0
echo
#Backup Config WinBOX
cp -r /$HOME/.local/share/MikroTik /$HOME/Nextcloud/backup-config/.local/share/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Remmina."
echo "######################################################"
tput sgr0
echo
#Backup Config Remmina
cp -r /$HOME/.local/share/remmina /$HOME/Nextcloud/backup-config/.local/share/

echo
tput setaf 3
echo "######################################################"
echo "################### Backup Config Zed."
echo "######################################################"
tput sgr0
echo
#Backup Config Zed
cp -r /$HOME/.local/share/zed /$HOME/Nextcloud/backup-config/.local/share/

echo
tput setaf 3
echo "######################################################"
echo "################### GNOME Shell."
echo "######################################################"
tput sgr0
echo
#Backup GNOME Shell
cp -r /$HOME/.local/share/gnome-shell /$HOME/Nextcloud/backup-config/.local/share/

echo
tput setaf 3
echo "######################################################"
echo "################### Bash."
echo "######################################################"
tput sgr0
echo
#Backup Bash
cp -r /$HOME/.bashrc /$HOME/Nextcloud/backup-config/
cp -r /$HOME/.bashrc-personal /$HOME/Nextcloud/backup-config/

echo
tput setaf 3
echo "######################################################"
echo "################### Fish."
echo "######################################################"
tput sgr0
echo
#Backup Fish
cp -r /$HOME/.config/fish /$HOME/Nextcloud/backup-config/.config/
