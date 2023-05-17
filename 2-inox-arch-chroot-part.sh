#! /bin/bash

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

touch /etc/hostname
echo "arch-inox" > /etc/hostname
echo "127.0.0.1		localhost
::1		localhost
127.0.1.1	arch-inox.localdomain	arch-inox" >> /etc/hosts

passwd
cd ..

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-lts-headers

grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

echo "\nNow EXIT, umount -a and REBOOT.
Then set up NetworkManager and start script nr 3."


