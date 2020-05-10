#!/bin/sh
# scan2folder tool

# install tools
sudo apt -y install ghostscript yad hplip-gui

# install yad
IS_PRESENT=$(command -v yad)
if [ -z "${IS_PRESENT}" ]
then
  sudo add-apt-repository -y ppa:webupd8team/y-ppa-manager
  sudo apt-get update
  sudo apt-get -y install yad
fi

# main script
sudo wget -O /usr/local/bin/scan2folder https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/scanner/scan2folder
sudo chmod +x /usr/local/bin/scan2folder

# configuration file
mkdir --parent $HOME/.config
wget -O $HOME/.config/scan2folder.conf https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/scanner/scan2folder.conf

# desktop integration
sudo wget -O /usr/share/applications/scan2folder.desktop https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/scanner/scan2folder.desktop
sudo chmod +x /usr/share/applications/scan2folder.desktop
