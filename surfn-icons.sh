#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Surfn Icons"
echo "######################################################"
tput sgr0
echo
# Surfn Icons

cd /home/$USER/
git clone https://github.com/erikdubois/Super-Ultra-Flat-Numix-Remix
cd surfn-icons/
cp -R * /home/$USER/icons/