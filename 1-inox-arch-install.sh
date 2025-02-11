#! /bin/bash

loadkeys pl

timedatectl set-timezone Europe/Warsaw
timedatectl set-ntp true

echo -e "\n\nSetting up pacman\n\n"
sleep 3

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

echo -e "\n\nsetting up reflector\n\n"

reflector -c Germany -a 6 --download-timeout 20 --connection-timeout 20 -l 7 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware neovim

echo -e "\n\ngenerating FSTAB\n\n"
sleep 5
genfstab -U /mnt >> /mnt/etc/fstab

git clone https://github.com/inox-vision/arch-install-scripts.git /mnt

arch-chroot /mnt /bin/bash /mnt/arch-install-scripts/2-inox-arch-chroot-part.sh




