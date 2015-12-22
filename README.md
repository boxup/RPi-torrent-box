#RPi-torrent-box

##Overview
This repository contains bash scripts for creating a torrent box using a Raspberry Pi with an external HDD storage device. 


##Prerequisites
1. Raspberry Pi Raspbian OS (other OS's haven't been tested)
2. External storage device accessible and usable by the Raspberry Pi
3. Internet connection for the Raspberry Pi

##Setup

###Initial source file setup
SSH into your Raspberry Pi and clone this repository.

###User Settings
The following values must be configured in the `install.sh` file:

```
# MAX_JOBS: Maximum number of torrents running
# EXT_NAME: Name of your external storage device
# TRANS_USERNAME: Username to login to the web-interface of transmission
# TRANS_PASSWORD: Password to login to the web-interface of transmission
# EXT_OWNER1: User owning the external drive, typically pi
# EXT_OWNER2: User owning the external drive, typically pi

```
###Runing the install
`./install.sh`

If you have correctly configured the user settings, you should now be able to enter transmission on your local machine through a web-interface. Open a web-browser and enter `http://RPi_ip:9091`. You will be prompted to enter a username and password, for which you have previously defined.

###Adding torrents
**Torrent File**

1. Download the torrent file on your local machine.
2. Click the folder icon on the transmission web-interface.
3. Click upload torrent file.
4. Click add.

**Magnetic Links**

1.	Find the address of the magnetic link.
2. Click the folder icon on the transmission web-interface.
3. Insert URL.
4. Click add.