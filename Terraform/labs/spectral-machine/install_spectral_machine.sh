#!/bin/bash

logfile="/var/tmp/install_spectral.log"
SF="git xfce4 xrdp mousepad"

echo "updating the system" > $logfile
sudo apt update

echo "installing $SF" >> $logfile
sudo apt install -y $SF

echo "enabling xrdp on system" >> $logfile
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert
echo xfce4-session >~/.xsession

echo "Restarting xrdp for login" >> $logfile
sudo service xrdp restart

echo "Installing Chrome" >> $logfile
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get -y --force-yes install -f
rm /tmp/google-chrome-stable_current_amd64.deb

mkdir $HOME/git
cd $HOME/git 
echo "Clone github Spectral Spectralgoat" >> $logfile
git clone https://github.com/chkp-cdiaz/SpectralGoat.git

echo "Clone PayloadAllTheThings" >> $logfile
git clone https://github.com/chkp-cdiaz/PayloadsAllTheThings.git

echo "Clone django-cdiaz" >> $logfile
git clone https://github.com/chkp-cdiaz/django-chkp.git

echo "Clone keystone" >> $logfile
git clone https://github.com/chkp-cdiaz/keystone.git
