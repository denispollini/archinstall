#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Install CPU Microcode and GPU Driver if is a Bare-metal system."
echo "######################################################"
tput sgr0
echo
# Install additional packages

# Function to check if the system is a virtual machine
is_virtual_machine() {
  # Use systemd-detect-virt to check if it's a virtual system
  if [[ $(systemd-detect-virt) != "none" ]]; then
    echo "Virtual machine detected. CPU ucode and GPU drivers will not be installed."
    return 0  # Confirm that it's a VM
  else
    echo "Bare-metal system detected. Proceeding with the appropriate package installation."
    return 1  # Confirm that it's bare-metal
  fi
}

# Function to detect CPU and install the appropriate ucode package
install_cpu_ucode() {
  CPU_VENDOR=$(lscpu | grep "Vendor ID:" | awk '{print $3}')
  if [[ $CPU_VENDOR == "GenuineIntel" ]]; then
    echo "Intel CPU detected. Installing intel-ucode."
    pacman -S intel-ucode --noconfirm --needed
  elif [[ $CPU_VENDOR == "AuthenticAMD" ]]; then
    echo "AMD CPU detected. Installing amd-ucode."
    pacman -S amd-ucode --noconfirm --needed
  else
    echo "Unrecognized CPU. No ucode package installed."
  fi
}

# Function to detect the GPU and install the appropriate drivers
install_gpu_drivers() {
  # Use lspci to detect the GPU
  GPU_VENDOR=$(lspci | grep -E "VGA|3D" | grep -oP "(Intel|AMD|NVIDIA)")
  
  if [[ $GPU_VENDOR == "AMD" ]]; then
    echo "AMD GPU detected. Installing xf86-video-amdgpu."
    pacman -S xf86-video-amdgpu --noconfirm --needed
  elif [[ $GPU_VENDOR == "NVIDIA" ]]; then
    echo "Nvidia GPU detected. Installing Nvidia drivers."
    pacman -S nvidia nvidia-utils nvidia-settings --noconfirm --needed
  else
    echo "No supported GPU detected or Intel GPU (no action needed)."
  fi
}

# Start of the script
echo "Starting installation process."

# Check if the system is a virtual machine
if is_virtual_machine; then
  echo "Proceeding without installing ucode or GPU packages for the VM."
else
  # If it's not a VM, install CPU and GPU packages
  install_cpu_ucode
  install_gpu_drivers
fi

echo
tput setaf 3
echo "######################################################"
echo "################### Install Chaotic Repo"
echo "######################################################"
tput sgr0
echo
# Install Chaotic Repo
yes | sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
yes | sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm --needed 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 
sudo pacman -U --noconfirm --needed 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' 
echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
yes | sudo pacman -Syu

echo
tput setaf 3
echo "######################################################"
echo "################### Install Software"
echo "######################################################"
tput sgr0
echo
# Install Install Software
sudo pacman -S linux-headers --noconfirm --needed
sudo pacman -S anydesk-bin --noconfirm --needed
sudo pacman -S rustdesk-bin --noconfirm --needed
sudo pacman -S base-devel --noconfirm --needed
sudo pacman -S bash-completion --noconfirm --needed
sudo pacman -S git --noconfirm --needed
sudo pacman -S go --noconfirm --needed
sudo pacman -S terminator --noconfirm --needed
sudo pacman -S vim --noconfirm --needed
sudo pacman -S yay-git --noconfirm --needed
sudo pacman -S brave-bin --noconfirm --needed
sudo pacman -S thunderbird --noconfirm --needed
sudo pacman -S virtualbox --noconfirm --needed
sudo pacman -S virtualbox-host-dkms --noconfirm --needed
sudo pacman -S virtualbox-guest-utils --noconfirm --needed
sudo pacman -S cryptomator --noconfirm --needed
sudo pacman -S openvpn --noconfirm --needed
sudo pacman -S keepassxc --noconfirm --needed
sudo pacman -S htop --noconfirm --needed
sudo pacman -S btop --noconfirm --needed

echo
tput setaf 3
echo "######################################################"
echo "################### Install and Change Shell to Fish"
echo "######################################################"
tput sgr0
echo
# Install and Change Shell to Fish
sudo pacman -S fish --noconfirm --needed
#chsh -s /usr/bin/fish $USER

echo
tput setaf 3
echo "######################################################"
echo "################### Enable Services"
echo "######################################################"
tput sgr0
echo
# Enable Services
sudo systemctl enable --now rustdesk
sudo systemctl enable --now vboxservice