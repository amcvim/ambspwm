#!/usr/bin/env bash

###
#  This script will configure bspwm on a lapopt/workstation/VM
###


### Install Xorg
# Upgrade & Install
   dnf -y upgrade && \

# Make dnf to install documentation 
   dnf -y install --setopt=tsflags='' \
   xorg-x11-server-Xorg \
   xorg-x11-server-common \
   xorg-x11-utils  \
   xorg-x11-xinit  \
   xorg-x11-font-utils \
   xorg-x11-fonts-100dpi \
   vim \
   tmux \
   git \
   xvkbd \
   rofi \
   neofetch \
   nodejs \
   firefox \
   lxappearance \
   thunar \
   konsole \
   bspwm \
   sxhkd \
   wpa_supplicant 

## Font configuration 
mkdir -p /usr/share/fonts/Inconsolata/
git  clone https://github.com/googlefonts/Inconsolata /tmp/Inconsolata
cp /tmp/Inconsolata/fonts/ttf/* /usr/share/fonts/Inconsolata/

## Configure bspwm dot files
mkdir -p  $HOME/.config/{bspwm,sxhkd} 

# Copy bspwmrc
cp  ../bspwm/bspwmrc /root/.config/bspwm/ 
## Copy .xinirc
cp ../bspwm/.xinitrc /root/.xinitrc

#
# Polybar 
#
   # Installation   
dnf -y install --setopt=tsflags=''  polybar
   # Configuration
mkdir -p /root/.config/polybar/example
cp ../polybar/config /root/.config/polybar/
cp ../polybar/launch.sh /root/.config/polybar/

#
## SXHKD
#
   # Configuration
cp ../sxhkd/sxhkdrc /root/.config/sxhkd/ 

#
## Keyboard mapping: Refactor, introduce proper conditional logic
#
if [[ -e  /usr/share/X11/xkb/keycodes/evdev ]]; then
  mv -f /usr/share/X11/xkb/keycodes/evdev{,.ini} 
fi
cp -r ../keyboard/evdev /usr/share/X11/xkb/keycodes/evdev

if [[ -e /usr/share/X11/xkb/symbols/us ]]; then
  mv -f /usr/share/X11/xkb/symbols/us{,.ini} 
fi
cp -r ../keyboard/us /usr/share/X11/xkb/symbols/us

## Konsole Configuration
cp ../konsole/konsolerc /root/.config/
mkdir -p /root/.local/share/konsole/
cp ../konsole/4k.profile /root/.local/share/konsole/

#
# Vim
#
echo -e  "\n#### >>> Configuring Vim\n"
cp -r ../vim/.vimrc ~/.vimrc


#
#  Coc extensions installatinon
#
echo -e  "\n#### >>> Configuring Coc\n"
#vim -c 'PluginInstall|q'
vim -c 'CocInstall -sync coc-pyright coc-snippets|qa'


#
# Tmux
#
echo -e  "\n#### >>> Configuring Tmux\n"
cp -r ../tmux/.tmux.conf /root/.tmux.conf

#
# TODO ssh
#


#
# Google Chrome
#
echo -e  "\n#### >>> Installing Googlge Chrome\n"
dnf -y install fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome
dnf -y install google-chrome-stable
## Configure it to run unde  root: Refactor this, it is horrible
sed '$d' /opt/google/chrome/google-chrome
echo 'exec -a "$0" "$HERE/chrome" "$@"--user-data-dir --test-type --no-sandbox' >> /opt/google/chrome/google-chrome


#
# Ramdisk: Refactor, this is horrible
#

echo -e  "\n#### >>> Configuring the RamDisk\n"
mkdir -p /ram
echo 'tmpfs       /ram     tmpfs   nodev,nosuid,noexec,nodiratime,size=1024M   0 0' >> /etc/fstab
mount -a

#
##  Wifi Configuration 
#  Leave this for last
#
systemctl enable wpa_supplicant
systemctl start  wpa_supplicant
systemctl restart NetworkManager

