#! /bin/bash

useradd -m -G wheel adrian
passwd adrian

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# system update
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf
sudo pacman -Syu


Window_manager="
	xorg
	xf86-video-intel
	qtile 
	lxappearance
	nitrogen
	picom
	archlinux-wallpaper
	lightdm
	lightdm-gtk-greeter
	"

pacman -S $Window_manager

sudo systemctl enable lightdm.service

echo "\nLog in as user and start script nr 4"

