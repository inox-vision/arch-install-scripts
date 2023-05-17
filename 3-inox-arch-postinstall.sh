#! /bin/bash

useradd -m -G wheel adrian
passwd adrian

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# system update
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf
sudo pacman -Syu

# basic utilities
sudo pacman -S htop neofetch base-devel git tree inxi alsa-utils

# power management
# sudo pacman -S powertop

# display server and driver
sudo pacman -S xf86-video-intel xorg

# Window manager
sudo pacman -S qtile lxappearance nitrogen picom archlinux-wallpaper lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service

echo "\nLog in as user and start script nr 4"

