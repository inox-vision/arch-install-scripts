#! /bin/bash

mkdir $HOME/git_clones
cd $HOME/git_clones

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

cd $HOME/git_clones
git clone https://aur.archlinux.org/insync.git
cd insync
makepkg -si

BASIC_utils="
	htop
	neofetch
	git
	tree
	inxi
	alsa-utils
	neovim
	duf
	speedtest-cli
	xarchiver
	p7zip
	unzip
	mousepad
	trash-cli
	ristretto
	reflector
	"

SYSTEM_utils="
	xfce4-terminal
	xfce4-power-manager
	bash-completion
	python-psutil
	powertop
	pipewire
	pipewire-alsa
	pipewire-jack
	pipewire-media-session
	pipewire-pulse
	sxhkd
	xclip
	btrfs-progs
	brother-mfc-j5910dw
	cups
	cups-filters
	ffmpeg
	pavucontrol
	qt5
	light-locker
	firewalld
	ipset
	iptables-nft
	"	

THEMING="
	gtk3
	breeze-gtk
	apparmor
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
	brave_bin
	qbittorrent
	flameshot
	evince
	libreoffice-still
	wireshark
	thunar
	tumbler
	geany
	visual-studio-code-bin
	joplin-desktop	
	whatsdesk-bin
	mpv
	"

VIRTUAL_machines="
	virt-manager
	qemu
	ovmf
	vde2
	ebtables
	dnsmasq
	bridge-utils
	openbsd-netcat
	vmware-workstation
	"

yay -S $BASIC_utils
yay -S $SYSTEM_utils
yay -S $THEMING
yay -S $OTHER_apps
yay -S $VIRTUAL_machines

sudo usermod -a -G wireshark adrian


# Enabling services

sudo systemctl enable apparmor.service
sudo systemctl enable reflector.timer
sudo systemctl enable firewalld.service
systemctl enable --user pulseaudio.service
systemctl start --user pulseaudio.service
systemctl enable --user insync.service
systemctl start --user insync.service


sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo chmod -a -G libvirt,libvirt-qemu adrian
sudo virsh net-start default
sudo virsh net-autostart default

# -------------------
# ---Configuration---
# -------------------

echo "XF86AudioRaiseVolume
    amixer -c 0 set Master 1dB+

XF86AudioLowerVolume
    amixer -c 0 set Master 1dB-

XF86AudioMute
    amixer -c 0 set Master 1+ toggle" > $HOME/.sxhkdrc
  
echo "
sxhkd -c ~/.sxhkdrc
nitrogen --restore
picom &
xfce4-power-manager &
flameshot &" > $HOME/.xprofile
  
echo "
alias ll='ls -l'
alias la='ls -la'
alias programowanie='cd ~/Insync/blindesign.pl@gmail.com/OneDrive/PROGRAMOWANIE'
alias vi='nvim'" >> $HOME/.bashrc

echo ":set tabstop=4
:set shiftwidth=4
:set expandtab
:set clipboard+=unnamedplus" > $HOME/.vimrc

echo "
--country Germany
--protocol https
--connection-timeout 30
--download-timeout 30
--latest 7
--sort rate
--save /etc/pacman.d/mirrorlist" > /etc/xdg/reflector/reflector.conf



echo "\nNow run powertop and --autotune it.
set up nitrogen.
"



# light-locker uruchomic
# ustawić wybór linuxa w grub

