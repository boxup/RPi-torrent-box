#!/bin/bash

#!/bin/bash

#### User Preferences ####

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

# Check prerequisites
#./get_prereq.sh

# Create torrent download directory in external storage device
mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/complete
mkdir -vp /media/pi/${EXT_NAME}/RPi_torrent_downloads/incomplete

DIR_COMPLETE=/media/pi/$EXT_NAME/RPi_torrent_downloads/complete
DIR_INCOMPLETE=/media/pi/$EXT_NAME/RPi_torrent_downloads/incomplete

sudo service transmission-daemon stop

# Modify Transmission settings.json file
sudo cp -i /etc/transmission-daemon/settings.json ./
sudo chmod 777 settings.json
grep -v "download-queue-size" settings.json > temp && mv temp settings.json
grep -v "download-dir" settings.json > temp && mv temp settings.json
grep -v "incomplete-dir" settings.json > temp && mv temp settings.json
grep -v "rpc-password" settings.json > temp && mv temp settings.json
grep -v "rpc-username" settings.json > temp && mv temp settings.json
grep -v "rpc-whitelist" settings.json > temp && mv temp settings.json
grep -v "incomplete-dir-enable" settings.json > temp && mv temp settings.json
grep -v "{" settings.json > temp && mv temp settings.json
#sudo rm /etc/transmission-daemon/settings.json