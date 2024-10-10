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

read -p "Enter the size for the root partition (e.g., 20G): " root_size
read -p "Enter the size for the swap partition (e.g., 4G): " swap_size

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

    # Root partition (user-defined size)
    echo n  # Add new partition
    echo 2  # Partition number
    echo    # Default first sector
    echo +$root_size  # Partition size

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
    read -p "Enter the size for the root partition (e.g., 20G): " root_size

    echo "Creating partitions on $DISK (BIOS)..."

    (
    echo o  # Create a new DOS (MBR) partition table

    # Root partition (user-defined size)
    echo n  # Add new partition
    echo p  # Primary partition
    echo 1  # Partition number
    echo    # Default first sector
    echo +$root_size  # Partition size

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
	mount --mkdir ${DISK}1 /mnt/boot
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

pacstrap -K /mnt base linux linux-firmware

echo
tput setaf 3
echo "######################################################"
echo "################### Configure the system"
echo "######################################################"
tput sgr0
echo
# Configure the system

genfstab -U /mnt >> /mnt/etc/fstab

read -p "Enter the Region (e.g., Italy,Germany,France): " region
read -p "Enter the Country (e.g., Rome): " country
read -p "Select your hostname: " hostname

# Function to choose DE
show_menu() {
    echo "You want install XFCE or install a DE manually later on?"
    echo "1) XFCE"
    echo "2) I install manually later."
}

read -p "Enter your choice (1-4): " DESKTOP

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
echo -e "LANG=en_US.UTF-8" >> /etc/locale.conf
echo -e "KEYMAP=it" >> /etc/vconsole.conf

echo $hostname >> /etc/hostname

echo
tput setaf 3
echo "######################################################"
echo "################### Initramfs"
echo "######################################################"
tput sgr0
echo
# Initramfs

mkinitcpio -P

echo
tput setaf 3
echo "######################################################"
echo "################### Set root password"
echo "######################################################"
tput sgr0
echo
# Set root password
passwd

echo
tput setaf 3
echo "######################################################"
echo "################### Install additional packages"
echo "######################################################"
tput sgr0
echo
# Install additional packages

pacman -S grub efibootmgr nano networkmanager os-prober sudo reflector xorg pulseaudio --noconfirm --needed 

echo
tput setaf 3
echo "######################################################"
echo "################### Select the mirrors"
echo "######################################################"
tput sgr0
echo
# Select the mirrors

reflector --country Italy --protocol https --latest 5 --save /etc/pacman.d/mirrorlist

echo
tput setaf 3
echo "######################################################"
echo "################### Install XFCE"
echo "######################################################"
tput sgr0
echo
# Install XFCE

if [[ "$DESKTOP" == "1" ]]; then
    pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter --noconfirm --needed
fi

echo
tput setaf 3
echo "######################################################"
echo "################### Install and Configure Grub Boot Loader"
echo "######################################################"
tput sgr0
echo
# Install and Configure Grub Boot Loader

if [[ "$platform_size" == "64" ]]; then
	grub-install --target=x86_64-efi --efi-directory=/boot/efi

else
	grub-install --target=i386-pc $DISK
fi

grub-mkconfig -o /boot/grub/grub.cfg
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
rm /mnt/chroot-script.sh
exit
umount -R /mnt
reboot
