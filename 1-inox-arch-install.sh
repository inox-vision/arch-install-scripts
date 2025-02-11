#! /bin/bash

loadkeys pl

timedatectl set-timezone Europe/Warsaw
timedatectl set-ntp true

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

reflector -c Germany -a 6 --download-timeout 20 --connection-timeout 20 -l 7 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware neovim

genfstab -U /mnt >> /mnt/etc/fstab

cd /mnt
git clone https://github.com/inox-vision/arch-install-scripts.git

arch-chroot /mnt

echo "\nStart script nr 2"



