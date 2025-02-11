#! /bin/bash

###############
# BASIC SETUP #
###############
echo -e "\n\nBasic Setup - locale, hostname etc.\n\n"
sleep 4

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=pl" > /etc/vconsole.conf

echo -e "Type in the hostname:\n"
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1		localhost
::1		localhost
127.0.1.1	$hostname.localdomain		$hostname" >> /etc/hosts

echo -e "\n\ndone\n\n"
sleep 2

################
# BASIC INSTAL #
################

pacman -S reflector --noconfirm
reflector -c Germany -a 6 --download-timeout 20 --connection-timeout 20 -l 7 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

INSTALL="
	grub
	neovim
	efibootmgr
	networkmanager
	network-manager-applet
	linux-headers
	sudo
	git
	base-devel
	"

pacman -S $INSTALL --noconfirm

echo -e "\n\nInstalling and configuring GRUB\n\n"
sleep 3

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg


################
#  USER SETUP  #
################

echo -e "\n\nUser setup\n\n"
sleep 3

passwd
echo -e "type in username.\n"
read username

useradd -m -G wheel $username
passwd $username

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

mkdir /home/$username/CLOUD
mkdir /home/$username/virt_machines
cd /home/$username
git clone https://github.com/inox-vision/arch-install-scripts.git






