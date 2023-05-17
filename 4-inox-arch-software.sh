#! /bin/bash

mkdir ~/git_clones
cd ~/git_clones

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

cd ~/git_clones
git clone https://aur.archlinux.org/insync.git
cd insync
makepkg -si

sudo pacman -S gtk3 breeze-gtk apparmor ttf-roboto ttf-opensans ttf-ms-fonts ttf-font-awesome xfce4-terminal xfce4-power-manager okular pcmanfm thunar bash-completion python-psutil powertop nvim pipewire pipewire-alsa pipewire-jack pipewire-media-session pipewire-pulse speedtest-cli


yay -S visual-studio-code-bin
yay -S mysql-workbench
yay -S brave-bin

sudo systemctl enable apparmor.service
systemctl enable --user pulseaudio.service
systemctl start --user pulseaudio.service
systemctl enable --user insync.service
systemctl start --user insync.service

touch .xprofile
echo "nitrogen --restore
picom &
xfce4-power-manager &" > ~/.xprofile

echo "alias ll='ls -l'
alias la='ls -la'
alias programowanie='cd ~/Insync/blindesign.pl@gmail.com/OneDrive/PROGRAMOWANIE'
alias vi='nvim'" >> ~/.bashrc

echo "\nNow run powertop and --autotune it.
set up nitrogen.
"
