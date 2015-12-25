#!/bin/bash
#===================================================================================
# User Preferences ####
# MAX_JOBS: Maximum number of torrents running
# EXT_NAME: Name of your external storage device
# TRANS_USERNAME: Username to login to the web-interface of transmission
# TRANS_PASSWORD: Password to login to the web-interface of transmission

#===================================================================================

MAX_JOBS="5";
EXT_NAME='2495-B2B3';
TRANS_USERNAME='admin';
TRANS_PASSWORD='admin';

echo '>> Check prerequisites'
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install transmission-daemon

echo '>> Create torrent download directory in external storage device'
mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/complete;
mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/incomplete;
DIR_COMPLETE='/media/pi/'$EXT_NAME'/RPi_torrent_downloads/complete';
DIR_INCOMPLETE='/media/pi/'$EXT_NAME'/RPi_torrent_downloads/incomplete';

echo '>> Modify Transmission settings.json file'
sudo sed -i 's/^.*rpc-whitelist".*$/    "rpc-whitelist": "192.168.*.*",/' /etc/transmission-daemon/settings.json
sudo sed -i 's/^.*download-queue-size".*$/    "download-queue-size": '$MAX_JOBS',/' /etc/transmission-daemon/settings.json
sudo sed -i 's\^.*download-dir".*$\    "download-dir": "'$DIR_COMPLETE'",\' /etc/transmission-daemon/settings.json
sudo sed -i 's\^.*incomplete-dir".*$\    "incomplete-dir": "'$DIR_INCOMPLETE'",\' /etc/transmission-daemon/settings.json
sudo sed -i 's/^.*rpc-username".*$/    "rpc-username": "'$TRANS_USERNAME'",/' /etc/transmission-daemon/settings.json
sudo sed -i 's/^.*rpc-password".*$/    "rpc-password": "'$TRANS_PASSWORD'",/' /etc/transmission-daemon/settings.json
sudo sed -i 's/^.*incomplete-dir-enable".*$/    "incomplete-dir-enable": true,/' /etc/transmission-daemon/settings.json

echo '>> Modify Transmission transmission-daemon file'
sudo sed -i 's/^.*USER=deb.*$/USER=pi/' /etc/init.d/transmission-daemon

echo '>> Owning some files'
sudo chown -R pi:pi /etc/transmission-daemon
sudo chown -R pi:pi /etc/init.d/transmission-daemon
sudo chown -R pi:pi /var/lib/transmission-daemon

echo '>> Modify Transmission transmission-daemon.service file'
sudo sed -i 's/^.*User=deb.*$/User=pi/' /etc/systemd/system/multi-user.target.wants/transmission-daemon.service

echo '>> Extra stuff'
sudo mkdir -p /home/pi/.config/transmission-daemon/
sudo ln -s /etc/transmission-daemon/settings.json /home/pi/.config/transmission-daemon/
sudo chown -R pi:pi /home/pi/.config/transmission-daemon/
sudo systemctl daemon-reload

sudo service transmission-daemon start