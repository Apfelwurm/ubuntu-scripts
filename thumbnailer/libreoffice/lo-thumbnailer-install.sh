#!/bin/sh
# LibreOffice thumbnailer

# test Ubuntu distribution
DISTRO=$(lsb_release -is 2>/dev/null)
[ "${DISTRO}" != "Ubuntu" ] && { zenity --error --text="This automatic installation script is for Ubuntu only"; exit 1; }

# install tools
sudo apt-get -y install libfile-mimeinfo-perl gvfs-bin unzip netpbm

# install thumbnailer icons
sudo mkdir /usr/local/sbin/lo-thumbnailer.res
sudo wget -O /usr/local/sbin/lo-thumbnailer.res/lo-database.png https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/icons/lo-database.png
sudo wget -O /usr/local/sbin/lo-thumbnailer.res/lo-graphics.png https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/icons/lo-graphics.png
sudo wget -O /usr/local/sbin/lo-thumbnailer.res/lo-presentation.png https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/icons/lo-presentation.png
sudo wget -O /usr/local/sbin/lo-thumbnailer.res/lo-spreadsheet.png https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/icons/lo-spreadsheet.png
sudo wget -O /usr/local/sbin/lo-thumbnailer.res/lo-text.png https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/icons/lo-text.png

# install main script
sudo wget -O /usr/local/sbin/lo-thumbnailer https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/lo-thumbnailer
sudo chmod +rx /usr/local/sbin/lo-thumbnailer

# thumbnailer integration
sudo wget -O /usr/share/thumbnailers/lo.thumbnailer https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/lo.thumbnailer

# if present, disable gsf-office.thumbnailer (used in UbuntuGnome 16.04)
[ -f "/usr/share/thumbnailers/gsf-office.thumbnailer" ] && sudo mv /usr/share/thumbnailers/gsf-office.thumbnailer /usr/share/thumbnailers/gsf-office.thumbnailer.org

# if apparmor installed,
if [ -d "/etc/apparmor.d" ]
then
  # declare the profile
  sudo wget -O /etc/apparmor.d/usr.local.sbin.lo-thumbnailer https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/thumbnailer/libreoffice/usr.local.sbin.lo-thumbnailer

  # reload apparmor profiles
  sudo service apparmor reload
fi

# stop nautilus
nautilus -q

# remove previously cached files (thumbnails and masks)
[ -d "$HOME/.cache/thumbnails" ] && rm --recursive --force $HOME/.cache/thumbnails/*
[ -d "$HOME/.thumbnails" ] && rm --recursive --force $HOME/.thumbnails/*
[ -d "$HOME/.cache/lo-thumbnailer" ] && rm --recursive --force $HOME/.cache/lo-thumbnailer
