#!/bin/bash

# Define Variables
DISK="/dev/sdX"  # CHANGE THIS TO YOUR DRIVE!
HOSTNAME="arch-machine"
USERNAME="user"

# Update system clock
timedatectl set-ntp true

# Partition the disk (GPT)
echo "Partitioning disk..."
parted -s $DISK mklabel gpt
parted -s $DISK mkpart primary fat32 1MiB 512MiB
parted -s $DISK set 1 esp on
parted -s $DISK mkpart primary linux-swap 512MiB 4GiB
parted -s $DISK mkpart primary ext4 4GiB 100%

# Format partitions
echo "Formatting partitions..."
mkfs.fat -F32 ${DISK}1
mkswap ${DISK}2
mkfs.ext4 ${DISK}3
swapon ${DISK}2

# Mount root partition
mount ${DISK}3 /mnt

# Install base system
echo "Installing base system..."
pacstrap /mnt base linux linux-firmware nano vim sudo

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configure system
arch-chroot /mnt bash <<EOF
echo "$HOSTNAME" > /etc/hostname

# Set timezone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Set locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Create user
useradd -m -G wheel -s /bin/bash $USERNAME
echo "$USERNAME:password" | chpasswd

# Enable sudo for wheel group
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel

# Install bootloader
pacman -Syu --noconfirm grub efibootmgr
mkdir /boot/efi
mount ${DISK}1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# Enable networking
systemctl enable NetworkManager
EOF

echo "Installation complete! Reboot and enjoy your Arch system."