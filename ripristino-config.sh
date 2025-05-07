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