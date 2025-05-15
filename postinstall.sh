#!/bin/bash

# Update the system
sudo pacman -Syu --noconfirm

# Install i3 window manager and essential utilities
sudo pacman -S --noconfirm i3-wm i3status i3lock dmenu xorg-xinit xterm picom

# Install NVIDIA drivers
sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Enable kernel mode setting for NVIDIA
echo -e "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf

# Generate Xorg config for NVIDIA
sudo nvidia-xconfig

# Install Steam
sudo pacman -S --noconfirm steam

# Install Brave browser
sudo pacman -S --noconfirm brave-browser

# Install OnlyOffice
sudo pacman -S --noconfirm onlyoffice-bin  # Using Chaotic AUR instead of compiling

# Install Vim and htop
sudo pacman -S --noconfirm vim htop

# Install a GTK theme manager
sudo pacman -S --noconfirm lxappearance

# Install GameMode (gaming performance tweaks)
sudo pacman -S --noconfirm gamemode

# Install Polybar for better status bar management in i3
sudo pacman -S --noconfirm polybar

# Enable multi-threading performance tweaks (optional)
sudo systemctl enable nvidia-persistenced

# Install networking tools
sudo pacman -S --noconfirm networkmanager
sudo systemctl enable NetworkManager

# Install PipeWire for audio management
sudo pacman -S --noconfirm pipewire pipewire-pulse wireplumber alsa-utils

# Install fonts
sudo pacman -S --noconfirm ttf-dejavu ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji

# Install an AUR helper (yay)
sudo pacman -S --noconfirm git
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si

# Install file manager
sudo pacman -S --noconfirm thunar gvfs

# Install terminal emulator
sudo pacman -S --noconfirm kitty

# Install clipboard manager
sudo pacman -S --noconfirm clipmenu

# Install GNOME keyring (for secure password storage)
sudo pacman -S --noconfirm gnome-keyring

# Enable Chaotic AUR repository
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf

sudo pacman -Syu --noconfirm  # Refresh package lists

# Install Bazzite Kernel
yay -S --noconfirm kernel-bazzite

# Set Bazzite Kernel as default
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Install Wine for Windows compatibility
sudo pacman -S --noconfirm wine wine-mono wine-gecko winetricks

# Install Lutris for managing games
sudo pacman -S --noconfirm lutris

# Install Proton-GE (custom Proton version for better compatibility)
yay -S --noconfirm proton-ge-custom  # Requires AUR helper

# Install DXVK for DirectX to Vulkan translation
sudo pacman -S --noconfirm dxvk-bin

# Enable DXVK for Wine
echo "export DXVK_HUD=1" | sudo tee -a /etc/environment
echo "export WINEPREFIX=~/.wine" | sudo tee -a /etc/environment
echo "export DXVK_CONFIG_FILE=~/.config/dxvk.conf" | sudo tee -a /etc/environment

# Install FSR (FidelityFX Super Resolution) for upscaling
yay -S --noconfirm gamescope

# Install VKD3D for DirectX 12 support
sudo pacman -S --noconfirm vkd3d

# Enable startup services
sudo systemctl enable gamemoded gamescope NetworkManager

# Create a basic .xinitrc for i3
echo "exec i3" > ~/.xinitrc

echo "Setup complete! You can start i3 with 'startx'."