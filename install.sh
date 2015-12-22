#!/bin/bash

#### User Preferences ####
##########################
# MAX_DOWN: Maximum download speed of a torrent
# MAX_UP: Maximum upload speed of a torrent
# MAX_JOBS: Maximum number of torrents running
# EXT_NAME: Name of your external storage device
# EXT_OWNER: User owning the external drive, typically pi

MAX_JOBS="5";
EXT_NAME="RAMAUSB";
TRANS_USERNAME="admin";
TRANS_PASSWORD="admin";
EXT_OWNER1='USER=pi'
EXT_OWNER2='User=pi'

##########################

# Check prerequisites
#./get_prereq.sh

# Create torrent download directory in external storage device
#mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/complete
#mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/incomplete

#DIR_COMPLETE=/media/pi/$EXT_NAME/RPi_torrent_downloads/complete
#DIR_INCOMPLETE=/media/pi/$EXT_NAME/RPi_torrent_downloads/incomplete
DIR_COMPLETE=/temp/
DIR_INCOMPLETE=/temp/

sudo service transmission-daemon stop

# Modify Transmission settings.json file
sudo cp -i /etc/transmission-daemon/settings.json ./
sudo chmod 777 settings.json

# Remove lines
grep -v "download-queue-size" settings.json > temp && mv temp settings.json
grep -v "download-dir" settings.json > temp && mv temp settings.json
grep -v "incomplete-dir" settings.json > temp && mv temp settings.json
grep -v "rpc-password" settings.json > temp && mv temp settings.json
grep -v "rpc-username" settings.json > temp && mv temp settings.json
grep -v "rpc-whitelist" settings.json > temp && mv temp settings.json
grep -v "incomplete-dir-enable" settings.json > temp && mv temp settings.json
grep -v "{" settings.json > temp && mv temp settings.json

# Add lines with user preferences
printf -v var '"download-queue-size": %s,' "$MAX_JOBS"
echo -e "\t$var" | cat - settings.json > temp && mv temp settings.json
printf -v var '"incomplete-dir-enable": %s,' "true"
echo -e "\t$var" | cat - settings.json > temp && mv temp settings.json
printf -v var '"rpc-whitelist": "%s",' "192.168.*.*"
echo -e "\t$var" | cat - settings.json > temp && mv temp settings.json
printf -v var '"rpc-username": "%s",' "$TRANS_USERNAME"
echo -e "\t$var" | cat - settings.json > temp && mv temp settings.json
printf -v var '"rpc-password": "%s",' "$TRANS_PASSWORD"
echo -e "\t$var" | cat - settings.json > temp && mv temp settings.json
printf -v var '"incomplete-dir": "%s",' "$DIR_INCOMPLETE"
echo -e "\t$var" | cat - settings.json > temp && mv temp settings.json
printf -v var '"download-dir": "%s",' "$DIR_COMPLETE"
echo -e "\t$var" | cat - settings.json > temp && mv temp settings.json
echo '{' | cat - settings.json > temp && mv temp settings.json
sudo chmod 644 settings.json

sudo rm /etc/transmission-daemon/settings.json
sudo mv ./settings.json /etc/transmission-daemon/settings.json

sudo service transmission-daemon reload
sudo service transmission-daemon stop

# Modify Transmission transmission-daemon file
sudo cp -i /etc/init.d/transmission-daemon ./
sudo chmod 777 transmission-daemon
grep -v "USER" transmission-daemon > temp && mv temp transmission-daemon
awk -v n=14 -v s=$EXT_OWNER1 'NR == n {print s} {print}' transmission-daemon > temp && mv temp transmission-daemon
sudo chmod 755 transmission-daemon
sudo rm /etc/init.d/transmission-daemon
sudo mv ./transmission-daemon /etc/init.d/transmission-daemon

# Owning some files
#sudo chown -R pi:pi /etc/transmission-daemon
#sudo chown -R pi:pi /etc/init.d/transmission-daemon
#sudo chown -R pi:pi /var/lib/transmission-daemon



