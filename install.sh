#!/bin/bash

#### User Preferences ####
##########################
# MAX_JOBS: Maximum number of torrents running
# EXT_NAME: Name of your external storage device
# TRANS_USERNAME: Username to login to the web-interface of transmission
# TRANS_PASSWORD: Password to login to the web-interface of transmission
# EXT_OWNER1: User owning the external drive, typically pi
# EXT_OWNER2: User owning the external drive, typically pi

MAX_JOBS="5";
EXT_NAME="07E2-7749";
TRANS_USERNAME="admin";
TRANS_PASSWORD="admin";
EXT_OWNER1='USER=pi'
EXT_OWNER2='User=pi'

##########################

# Check prerequisites
#./get_prereq.sh

# Create torrent download directory in external storage device
mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/complete
mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/incomplete

DIR_COMPLETE=/media/pi/$EXT_NAME/RPi_torrent_downloads/complete
DIR_INCOMPLETE=/media/pi/$EXT_NAME/RPi_torrent_downloads/incomplete

echo 'Modify Transmission settings.json file'
#sudo service transmission-daemon stop

# Remove lines
sudo grep -v "download-queue-size" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo grep -v "download-dir" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo grep -v "incomplete-dir" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo grep -v "rpc-password" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo grep -v "rpc-username" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo grep -v "rpc-whitelist" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo grep -v "incomplete-dir-enable" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo grep -v "{" /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json

# Add lines with user preferences
printf -v var '"download-queue-size": %s,' "$MAX_JOBS"
sudo echo -e "\t$var" | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
printf -v var '"incomplete-dir-enable": %s,' "true"
sudo echo -e "\t$var" | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
printf -v var '"rpc-whitelist": "%s",' "192.168.*.*"
sudo echo -e "\t$var" | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
printf -v var '"rpc-username": "%s",' "$TRANS_USERNAME"
sudo echo -e "\t$var" | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
printf -v var '"rpc-password": "%s",' "$TRANS_PASSWORD"
sudo echo -e "\t$var" | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
printf -v var '"incomplete-dir": "%s",' "$DIR_INCOMPLETE"
sudo echo -e "\t$var" | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
printf -v var '"download-dir": "%s",' "$DIR_COMPLETE"
sudo echo -e "\t$var" | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo echo '{' | cat - /etc/transmission-daemon/settings.json > temp && mv temp /etc/transmission-daemon/settings.json
sudo chmod 600  /etc/transmission-daemon/settings.json
sudo chown -R debian-transmission:debian-transmission /etc/transmission-daemon/settings.json
sudo rm -f /home/pi/.config/transmission-daemon/settings.json
sudo ln -sf /etc/transmission-daemon/settings.json /home/pi/.config/transmission-daemon/settings.json
sudo service transmission-daemon reload
sudo service transmission-daemon stop

echo 'Modify Transmission transmission-daemon file'
sudo grep -v "USER" /etc/init.d/transmission-daemon > temp && mv temp /etc/init.d/transmission-daemon
sudo awk -v n=14 -v s=$EXT_OWNER1 'NR == n {print s} {print}' /etc/init.d/transmission-daemon > temp && mv temp /etc/init.d/transmission-daemon

echo 'Owning some files'
sudo chown -R pi:pi /etc/transmission-daemon
sudo chown -R pi:pi /etc/init.d/transmission-daemon
sudo chown -R pi:pi /var/lib/transmission-daemon
sudo chown -R pi:pi /etc/systemd/system/multi-user.target.wants/transmission-daemon.service

echo 'Modify Transmission transmission-daemon.service file'
sudo grep -v "User" /etc/systemd/system/multi-user.target.wants/transmission-daemon.service > temp && mv temp /etc/systemd/system/multi-user.target.wants/transmission-daemon.service
sudo awk -v n=6 -v s=$EXT_OWNER2 'NR == n {print s} {print}' /etc/systemd/system/multi-user.target.wants/transmission-daemon.service > temp && mv temp /etc/systemd/system/multi-user.target.wants/transmission-daemon.service

echo 'Extra stuff'
sudo systemctl daemon-reload

sudo mkdir -p /home/pi/.config/transmission-daemon/
sudo rm -f /home/pi/.config/transmission-daemon/settings.json
sudo ln -sf /etc/transmission-daemon/settings.json /home/pi/.config/transmission-daemon/
sudo chown -R pi:pi /home/pi/.config/transmission-daemon/

sudo service transmission-daemon start

