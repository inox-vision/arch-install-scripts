#! /bin/bash

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
sleep 3

mkdir $HOME/git_clones
cd $HOME/git_clones
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


yay -S $Window_manager --noconfirm
yay -S $BASIC_utils --noconfirm
yay -S $SYSTEM_utils --noconfirm
yay -S $THEMING --noconfirm
yay -S $OTHER_apps --noconfirm
yay -S $VIRTUAL_machines --noconfirm
yay -S $SOUND --noconfirm
yay -S $PRINTING --noconfirm


######################
#  EABLING SERVICES  #
######################


sudo systemctl enable lightdm.service
sudo systemctl enable NetworkManager
sudo systemctl enable apparmor.service
sudo systemctl enable firewalld.service
sudo systemctl enable cups
sudo systemctl enable --global pipewire.service
sudo systemctl enable libvirtd.service
sudo usermod -a -G libvirt $USER



###################
#  CONFIGURATION  #
###################

echo "setxkbmap pl
source ~/.bashrc" > $HOME/.bash_profile

## NEOVIM

echo ":set tabstop=4
:set shiftwidth=4
:set expandtab
:set clipboard+=unnamedplus" > $HOME/.vimrc


## SOUND BUTTONS

echo "XF86AudioRaiseVolume
    amixer -c 0 set Master 1dB+

XF86AudioLowerVolume
    amixer -c 0 set Master 1dB-

XF86AudioMute
    amixer -c 0 set Master 1+ toggle" > $HOME/.sxhkdrc

## XPROFILE

echo "
sxhkd -c ~/.sxhkdrc &
nitrogen --restore
picom &
xfce4-power-manager &
flameshot &
nextcloud &
setxkbmap pl" > $HOME/.xprofile
 
## WALLPAPER

mkdir $HOME/Pictures
cp arch-install-scripts/wallpaperflare.com_wallpaper2.jpg $HOME/Pictures/wallpaperflare.com_wallpaper2.jpg
echo "[xin_-1]
file=$HOME/Pictures/wallpaperflare.com_wallpaper2.jpg
mode=4
bgcolor=#000000" > $HOME/.config/nitrogen/bg-saved.cfg


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
</network>" > $HOME/virt_machines/br.xml


## QTILE

cp arch-install-scripts/config.py $HOME/.config/qtile/
cp arch-install-scripts/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
cp arch-install-scripts/xfce4-power-manager.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
cp arch-install-scripts/thunar.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
cp arch-install-scripts/init.vim $HOME/.config/nvim/
cp arch-install-scripts/.bashrc $HOME/
sudo cp arch-install-scripts/30-touchpad.conf /etc/X11/xorg.conf.d/

sudo virsh net-create $HOME/virt_machines/br.xml
sudo virsh net-autostart br10



# MKINITCPIO - encrypt dodać w hooks

# GRUB cryptdevice=UUID=device-UUID:root root=/dev/mapper/root w kernel parameters

