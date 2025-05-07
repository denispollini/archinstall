#!/bin/bash

# Customize with your own GitHub info
GIT_USERNAME="denispollini"
GIT_NAME="Denis Pollini"
GIT_EMAIL="denis.pollini.90@gmail.com"

project=$(basename `pwd`)

echo
tput setaf 3
echo "################################################################"
echo "################### Starting Git & SSH setup"
echo "################################################################"
tput sgr0
echo

echo "-----------------------------------------------------------------------------"
echo "This is the project: https://github.com/$GIT_USERNAME/$project"
echo "-----------------------------------------------------------------------------"

# Git global configuration
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global pull.rebase false
git config --global push.default simple
git config --global core.editor "nano"  # Or change to your preferred editor

# Set SSH URL for remote
git remote set-url origin git@github.com:$GIT_USERNAME/$project

# SSH key setup
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
    echo "Generating a new SSH key (ed25519)..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
else
    echo "SSH key already exists: $SSH_KEY"
fi

# Start SSH agent and add the key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

# Show public key to add on GitHub
echo
echo "🔑 Public SSH key to add to GitHub:"
echo "Go to: https://github.com/settings/ssh/new"
echo
cat "$SSH_KEY.pub"
echo

tput setaf 3
echo "################################################################"
echo "################### Setup complete"
echo "################################################################"
tput sgr0
echo
