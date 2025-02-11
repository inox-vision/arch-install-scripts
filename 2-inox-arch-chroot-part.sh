#! /bin/bash

###############
# BASIC SETUP #
###############

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

INSTALL="
	grub
	neovim
	efibootmgr
	networkmanager
	network-manager-applet
	linux-headers
	sudo
	"
Window_manager="
	xorg
	mesa
	qtile 
	lxappearance
	nitrogen
	picom
	lightdm
	lightdm-gtk-greeter
	"

BASIC_utils="
	inxi
	htop
	duf
	speedtest-cli
	xarchiver
	p7zip
	unzip
	"

SYSTEM_utils="
	xfce4-terminal
	xfce4-power-manager
	bash-completion
	python-psutil
	powertop
	tuned
	auto-cpufreq
	sxhkd
	xclip
	apparmor
	firewalld
	cifs-utils
	"	

THEMING="
	gtk3
	qt5
	breeze-gtk
	ttf-roboto
	ttf-opensans
	ttf-ms-fonts
	ttf-font-awesome
	ttf-mononoki-nerd
	ttf-hack-nerd
	adobe-source-code-pro-fonts
	adwaita-cursors
	adwaita-icon-theme
	"

OTHER_apps="
	thunderbird
	brave-bin
	qbittorrent
	flameshot
	evince
	libreoffice-still
	ristretto
	thunar
	ffmpeg
	ffmpegthumbnailer
	tumbler
	code
	whatsdesk-bin
	mpv
	nextcloud-client
	"

VIRTUAL_machines="
	virt-manager
	qemu
	ovmf
	vde2
	dnsmasq
	bridge-utils
	docker
	"

SOUND="
	alsa-utils
	pipewire
	pipewire-alsa
	pipewire-jack
	pipewire-pulse
	"

PRINTING="
	brother-mfc-j5910dw
	cups
	cups-filters
	system-config-printer
	"

echo -e "Installing YAY \n"
sleep 2

mkdir /home/adrian/git_clones
cd /home/adrian/git_clones
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

pacman -S reflector
reflector -c Germany -a 6 --download-timeout 20 --connection-timeout 20 -l 7 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf


pacman -S $INSTALL
pacman -S $Window_manager
yay -S $BASIC_utils
yay -S $SYSTEM_utils
yay -S $THEMING
yay -S $OTHER_apps
yay -S $VIRTUAL_machines
yay -S $SOUND
yay -S $PRINTING



################
#  USER SETUP  #
################


passwd
echo -e "type in username.\n"
read username

useradd -m -G wheel $username
passwd $username

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

usermod -a -G libvirt $username
mkdir /home/$username/CLOUD
mkdir /home/$username/virt_machines


######################
#  EABLING SERVICES  #
######################


systemctl enable lightdm.service
systemctl enable NetworkManager
systemctl enable apparmor.service
systemctl enable firewalld.service
systemctl enable cups
systemctl enable --global pipewire.service
systemctl enable libvirtd.service



###################
#  CONFIGURATION  #
###################

echo "setxkbmap pl
source ~/.bashrc" > /home/$username/.bash_profile

## NEOVIM

echo ":set tabstop=4
:set shiftwidth=4
:set expandtab
:set clipboard+=unnamedplus" > /home/$username/.vimrc


## SOUND BUTTONS

echo "XF86AudioRaiseVolume
    amixer -c 0 set Master 1dB+

XF86AudioLowerVolume
    amixer -c 0 set Master 1dB-

XF86AudioMute
    amixer -c 0 set Master 1+ toggle" > /home/$username/.sxhkdrc

## XPROFILE

echo "
sxhkd -c ~/.sxhkdrc &
nitrogen --restore
picom &
xfce4-power-manager &
flameshot &
nextcloud &
setxkbmap pl" > /home/$username/.xprofile
 
## WALLPAPER

mkdir /home/$username/Pictures
cp arch-install-scripts/wallpaperflare.com_wallpaper2.jpg /home/$username/Pictures/wallpaperflare.com_wallpaper2.jpg
echo "[xin_-1]
file=/home/$username/Pictures/wallpaperflare.com_wallpaper2.jpg
mode=4
bgcolor=#000000" > /home/$username/.config/nitrogen/bg-saved.cfg


echo "<network>
  <name>br10</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='br10' stp='on' delay='0'/>
  <ip address='192.168.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.30.50' end='192.168.30.200'/>
    </dhcp>
  </ip>
</network>" > /home/$username/virt_machines/br.xml


## QTILE

cp arch-install-scripts/config.py /home/$username/.config/qtile/
cp arch-install-scripts/xfce4-terminal.xml /home/$username/.config/xfce4/xfconf/xfce-perchannel-xml/
cp arch-install-scripts/xfce4-power-manager.xml /home/$username/.config/xfce4/xfconf/xfce-perchannel-xml/
cp arch-install-scripts/thunar.xml /home/$username/.config/xfce4/xfconf/xfce-perchannel-xml/
cp arch-install-scripts/init.vim /home/$username/.config/nvim/
cp arch-install-scripts/.bashrc /home/$username/

virsh net-create /home/$username/virt_machines/br.xml
virsh net-autostart br10

chown -R $username:$username /home/$username

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg



# MKINITCPIO - encrypt dodać w hooks

# GRUB cryptdevice=UUID=device-UUID:root root=/dev/mapper/root w kernel parameters

# Skopiować plik konfiguracyjny myszki z /etc/X11/xorg.conf
# Utworzyć systemd unit dla powertop i uruchomić


