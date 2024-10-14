#!/bin/bash
set -e

echo
tput setaf 3
echo "######################################################"
echo "################### Set keymaps"
echo "######################################################"
tput sgr0
echo
# Set keymaps
loadkeys it

echo
tput setaf 3
echo "######################################################"
echo "################### Check the connectivity"
echo "######################################################"
tput sgr0
echo
# Check the connectivity
echo "Check internet connection..."
ping -c 3 archlinux.org >/dev/null 2>&1

# Check if the ping command has been success.
if [[ $? -eq 0 ]]; then
    echo "Internet connection success."
else
    echo "No internet connection, please verify."
    exit 1  # Stop script
fi

echo
tput setaf 3
echo "######################################################"
echo "################### Update system clock"
echo "######################################################"
tput sgr0
echo
# Update system clock
timedatectl

echo
tput setaf 3
echo "######################################################"
echo "################### Partition the disks"
echo "######################################################"
tput sgr0
echo
# Partition the disks

# List the available disks using lsblk
echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL

# Ask the user which disk to partition
read -p "Enter the disk to partition (e.g., /dev/sda): " DISK

# Check if the selected disk exists
if [ ! -b "$DISK" ]; then
    echo "Invalid disk. Exiting."
    exit 1
fi

echo
tput setaf 3
echo "######################################################"
echo "################### Check the system if it's booted in BIOS or UEFI mode"
echo "######################################################"
tput sgr0
echo
# Check if the system is in UEFI mode
platform_size=$(cat /sys/firmware/efi/fw_platform_size 2>/dev/null)

# Warning to the user
echo "WARNING: This script will erase all data on $DISK."
read -p "Are you sure you want to continue? Type 'YES' to proceed: " confirm
if [[ "$confirm" != "YES" ]]; then
    echo "Operation canceled."
    exit 1
fi

# Ask the user whether to create a swap partition
read -p "Do you want to create a swap partition? (y/n): " create_swap

if [[ "$create_swap" == "y" ]]; then
    read -p "Enter the size for the swap partition (e.g., 4G): " swap_size
fi

# If the system is in UEFI mode, create 3 partitions (EFI, root, swap if desired)
if [[ $? -eq 0 && "$platform_size" == "64" ]]; then
    echo "The system is in UEFI mode. Proceeding with partition creation."

    # Create partitions for UEFI
    echo "Creating partitions on $DISK (UEFI)..."

    (
    echo g  # Create a new GPT partition table

    # EFI partition (500MB)
    echo n  # Add new partition
    echo 1  # Partition number
    echo    # Default first sector
    echo +500M  # Partition size
    echo t  # Change partition type
    echo ef  # Set type to EFI (type 1)

    # Swap partition (optional)
    if [[ "$create_swap" == "y" ]]; then
        echo n  # Add new partition
        echo 3  # Partition number
        echo    # Default first sector
        echo +$swap_size  # Partition size
        echo t  # Change partition type
        echo 3  # Select third partition (swap)
        echo 82 # Set partition type to Linux swap
    fi

    # Root partition (user-defined size)
    echo n  # Add new partition
    echo 2  # Partition number
    echo    # Default first sector
    echo    # Take the remain space on disk

    echo w  # Write changes to the disk
    ) | fdisk "$DISK"

    # Ask the user for the file system type for the root partition
    read -p "Choose the file system for the root partition (ext4, xfs, btrfs): " fs_type

    # Format the partitions
    echo "Formatting the partitions..."

    # Format EFI partition
    mkfs.fat -F32 "${DISK}1"

    # Format root partition based on user choice
    case $fs_type in
        ext4) mkfs.ext4 "${DISK}2";;
        xfs) mkfs.xfs "${DISK}2";;
        btrfs) mkfs.btrfs "${DISK}2";;
        *) echo "Invalid file system type. Exiting."; exit 1;;
    esac

    # Create and activate swap partition if chosen
    if [[ "$create_swap" == "y" ]]; then
        mkswap "${DISK}3"
        swapon "${DISK}3"
    fi

    echo "Partitioning and formatting completed (UEFI mode)."

else
    # If the system is in BIOS mode, create only root and (optional) swap partitions
    echo "The system is in BIOS mode. Proceeding with partition creation (root and optional swap)."

    # Ask the user for the sizes of the partitions
   
    echo "Creating partitions on $DISK (BIOS)..."

    (
    echo o  # Create a new DOS (MBR) partition table

    # Swap partition (optional)
    if [[ "$create_swap" == "y" ]]; then
        read -p "Enter the size for the swap partition (e.g., 4G): " swap_size
        echo n  # Add new partition
        echo p  # Primary partition
        echo 2  # Partition number
        echo    # Default first sector
        echo +$swap_size  # Partition size
        echo t  # Change partition type
        echo 2  # Select second partition (swap)
        echo 82 # Set partition type to Linux swap
    fi

    # Root partition (user-defined size)
    echo n  # Add new partition
    echo p  # Primary partition
    echo 1  # Partition number
    echo    # Default first sector
    echo    # Take the remain space on disk

    echo w  # Write changes to the disk
    ) | fdisk "$DISK"

    # Ask the user for the file system type for the root partition
    read -p "Choose the file system for the root partition (ext4, xfs, btrfs): " fs_type

    # Format the partitions
    echo "Formatting the partitions..."

    # Format root partition based on user choice
    case $fs_type in
        ext4) mkfs.ext4 "${DISK}1";;
        xfs) mkfs.xfs "${DISK}1";;
        btrfs) mkfs.btrfs "${DISK}1";;
        *) echo "Invalid file system type. Exiting."; exit 1;;
    esac

    # Create and activate swap partition if chosen
    if [[ "$create_swap" == "y" ]]; then
        mkswap "${DISK}2"
        swapon "${DISK}2"
    fi

    echo "Partitioning and formatting completed (BIOS mode)."
fi

echo "Operation completed."

echo
tput setaf 3
echo "######################################################"
echo "################### Mount the file systems"
echo "######################################################"
tput sgr0
echo
# Mount the file systems

if [[ "$platform_size" == "64" ]]; then
	mount ${DISK}2 /mnt
	mount --mkdir ${DISK}1 /mnt/boot/efi
else
	mount ${DISK}2 /mnt
fi

echo
tput setaf 3
echo "######################################################"
echo "################### Install essential packages"
echo "######################################################"
tput sgr0
echo
# Install essential packages

pacstrap -K /mnt base linux linux-firmware git vim nano 

echo
tput setaf 3
echo "######################################################"
echo "################### Configure the system"
echo "######################################################"
tput sgr0
echo
# Configure the system

genfstab -U /mnt >> /mnt/etc/fstab

echo
tput setaf 3
echo "######################################################"
echo "################### Request some data"
echo "######################################################"
tput sgr0
echo
# Choose DE
read -p "Enter the Region (e.g., Europe,America): " region
read -p "Enter the Country (e.g., Rome): " country
read -p "Select your hostname: " hostname
read -sp "Please set a password for root user: " root_password
read -p "Please enter your username: " user
read -sp "Please set a password: " password

cat << EOF > /mnt/chroot-script.sh
echo
tput setaf 3
echo "######################################################"
echo "################### Time"
echo "######################################################"
tput sgr0
echo
# Time
ln -sf /usr/share/zoneinfo/$region/$country /etc/localtime
hwclock --systohc

echo
tput setaf 3
echo "######################################################"
echo "################### Localization"
echo "######################################################"
tput sgr0
echo
# Localization

sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo -e "LANG=en_US.UTF-8" >> /etc/locale.conf
echo -e "KEYMAP=it" >> /etc/vconsole.conf

echo $hostname >> /etc/hostname

cat << EOF1 >> /etc/hosts
127.0.0.1      localhost
::1            localhost
127.0.1.1      $hostname.localdomain    $hostname
EOF1

echo
tput setaf 3
echo "######################################################"
echo "################### Set root password"
echo "######################################################"
tput sgr0
echo
# Set root password
echo root:$root_password | chpasswd

echo
tput setaf 3
echo "######################################################"
echo "################### Install additional packages"
echo "######################################################"
tput sgr0
echo
# Install additional packages

pacman -S grub --noconfirm --needed                 
pacman -S efibootmgr --noconfirm --needed
pacman -S os-prober --noconfirm --needed
pacman -S networkmanager --noconfirm --needed
pacman -S network-manager-applet --noconfirm --needed
pacman -S dialog --noconfirm --needed
pacman -S wpa_supplicant --noconfirm --needed
pacman -S mtools --noconfirm --needed
pacman -S dosfstools --noconfirm --needed
pacman -S base-devel --noconfirm --needed
pacman -S linux-headers --noconfirm --needed
pacman -S avahi --noconfirm --needed
pacman -S xdg-user-dirs --noconfirm --needed
pacman -S xdg-utils --noconfirm --needed
pacman -S gvfs --noconfirm --needed
pacman -S gvfs-smb --noconfirm --needed
pacman -S nfs-utils --noconfirm --needed
pacman -S inet-utils --noconfirm --needed
pacman -S dnsutils --noconfirm --needed
pacman -S bluez --noconfirm --needed
pacman -S bluez-utils --noconfirm --needed
pacman -S cups --noconfirm --needed
pacman -S hplip --noconfirm --needed
pacman -S alsa-utils --noconfirm --needed
pacman -S pulseaudio --noconfirm --needed
pacman -S bash-completion --noconfirm --needed
pacman -S openssh --noconfirm --needed
pacman -S rsync --noconfirm --needed
pacman -S reflector --noconfirm --needed
pacman -S acpi --noconfirm --needed
pacman -S acpi_call --noconfirm --needed
pacman -S tlp --noconfirm --needed
pacman -S virt-manager --noconfirm --needed
pacman -S qemu --noconfirm --needed
pacman -S qemu-arch-extra --noconfirm --needed
pacman -S ovmf --noconfirm --needed
pacman -S bridge-utils --noconfirm --needed
pacman -S dnsmasq --noconfirm --needed
pacman -S vde2 --noconfirm --needed
pacman -S openbsd-netcat --noconfirm --needed
pacman -S ebtables --noconfirm --needed
pacman -S iptables --noconfirm --needed
pacman -S ipset --noconfirm --needed
pacman -S firewalld --noconfirm --needed
pacman -S flatpak --noconfirm --needed
pacman -S sof-firmware --noconfirm --needed
pacman -S nss-mdns --noconfirm --needed
pacman -S acpid --noconfirm --needed

# Uncomment if you have AMD or Intel CPU only for bare-metal not VM or Container

pacman -S amd-ucode --noconfirm --needed
pacman -S intel-ucode --noconfirm --needed

# Uncomment if you have AMD or Nvidia GPU

# pacman -S xf86-video-amdgpu --noconfirm --needed
# pacman -S nvidia nvidia-utils nvidia-settings --noconfirm --needed

echo
tput setaf 3
echo "######################################################"
echo "################### Install and Configure Grub Boot Loader"
echo "######################################################"
tput sgr0
echo
# Install and Configure Grub Boot Loader

if [[ "$platform_size" == "64" ]]; then
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

else
    grub-install --target=i386-pc $DISK
fi

grub-mkconfig -o /boot/grub/grub.cfg

echo
tput setaf 3
echo "######################################################"
echo "################### Enable Services"
echo "######################################################"
tput sgr0
echo
# Enable Services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable sshd
systemctl enable avahi-deamon
systemctl enable tlp
systemctl reflector.timer
systemctl fstrim.timer
systemctl libvirtd
systemctl firewalld
systemctl acpid

echo
tput setaf 3
echo "######################################################"
echo "################### Add User"
echo "######################################################"
tput sgr0
echo
# Add User

useradd -m $user
usermod -aG libvirt $user
echo $user:$password | chpasswd
echo "$user ALL=[ALL] ALL" >> /etc/sudoers.d/$user
EOF

echo
tput setaf 3
echo "######################################################"
echo "################### CHROOT Script"
echo "######################################################"
tput sgr0
echo
# Chroot Script

arch-chroot /mnt /bin/bash /chroot-script.sh

echo
tput setaf 3
echo "######################################################"
echo "################### Exit CHROOT and Reboot"
echo "######################################################"
tput sgr0
echo
# Exit CHROOT and Reboot

# Remove the script inside the chroot
rm /mnt/chroot-script.sh

# Unmount all partitions
umount -R /mnt

# Reboot the system
reboot


