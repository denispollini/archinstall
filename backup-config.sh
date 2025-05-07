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
