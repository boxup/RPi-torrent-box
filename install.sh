#!/bin/bash
#===================================================================================
# User Preferences ####
# MAX_JOBS: Maximum number of torrents running
# EXT_NAME: Name of your external storage device
# TRANS_USERNAME: Username to login to the web-interface of transmission
# TRANS_PASSWORD: Password to login to the web-interface of transmission
# EXT_OWNER1: User owning the external drive, typically pi
# EXT_OWNER2: User owning the external drive, typically pi

#===================================================================================

MAX_JOBS="5";
EXT_NAME="07E2-7749";
TRANS_USERNAME="admin";
TRANS_PASSWORD="admin";
EXT_OWNER='USER=pi';

echo '>> Check prerequisites'
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install transmission-daemon

echo '>> Create torrent download directory in external storage device'
tdir=/media/pi/${EXT_NAME}/RPi_torrent_downloads/complete;
DIR_COMPLETE=$tdir;
tdir=/media/pi/${EXT_NAME}/RPi_torrent_downloads/incomplete;
DIR_INCOMPLETE=$tdir;

echo '>> Modify Transmission settings.json file'
sed -i 's/^.*rpc-whitelist.*$/ "rpc-whitelist": "192.168.*.*"/' /etc/transmission-daemon/settings.json
sed -i 's/^.*download-queue-size.*$/ "download-queue-size": '$MAX_JOBS',/' /etc/transmission-daemon/settings.json
sed -i 's/^.*download-dir.*$/ "download-dir": '$DIR_COMPLETE',/' /etc/transmission-daemon/settings.json
sed -i 's/^.*incomplete-dir.*$/ "incomplete-dir": '$DIR_INCOMPLETE',/' /etc/transmission-daemon/settings.json
sed -i 's/^.*rpc-username.*$/ "rpc-username": '$TRANS_USERNAME',/' /etc/transmission-daemon/settings.json
sed -i 's/^.*rpc-password.*$/ "rpc-password": '$TRANS_PASSWORD',/' /etc/transmission-daemon/settings.json
sed -i 's/^.*incomplete-dir-enable.*$/ "incomplete-dir-enable": true,/' /etc/transmission-daemon/settings.json
sudo service transmission-daemon reload
sudo service transmission-daemon stop

echo '>> Modify Transmission transmission-daemon file'
sed -i 's/^.*USER=Deb.*$/ '$EXT_OWNER'/' /etc/init.d/transmission-daemon

echo '>> Owning some files'
sudo chown -R pi:pi /etc/transmission-daemon
sudo chown -R pi:pi /etc/init.d/transmission-daemon
sudo chown -R pi:pi /var/lib/transmission-daemon

echo '>> Modify Transmission transmission-daemon.service file'
sed -i 's/^.*USER=Deb.*$/ '$EXT_OWNER'/' /etc/systemd/system/multi-user.target.wants/transmission-daemon.service

echo '>> Extra stuff'
sudo systemctl daemon-reload
sudo mkdir -p /home/pi/.config/transmission-daemon/
sudo ln -sf /etc/transmission-daemon/settings.json /home/pi/.config/transmission-daemon/
sudo chown -R pi:pi /home/pi/.config/transmission-daemon/
sudo service transmission-daemon start