# Restart transmission service
echo 'Restarting transmission'
sudo service transmission-daemon stop
echo 'Stopped service'
sudo service transmission-daemon start
echo 'Service started'
