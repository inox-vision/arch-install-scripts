#! /bin/bash

loadkeys pl

timedatectl set-timezone Europe/Warsaw
timedatectl set-ntp true

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p4
#mkfs.ext4 /dev/nvme0n1p5
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2

mount /dev/nvme0n1p4 /mnt
mkdir -p /mnt/boot/EFI
mount /dev/nvme0n1p1 /mnt/boot/EFI
mkdir /mnt/home
mount /dev/nvme0n1p5 /mnt/home

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

reflector -c Germany -a 6 --download-timeout 20 --connection-timeout 20 -l 7 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware 

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

echo "\nStart script nr 2"



