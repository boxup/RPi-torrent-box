# Check network connection of pi
sudo ping -c4 192.168.1.1 > /dev/null
if [ ping != 0 ] 
then
	echo 'Network connection failed'
	sudo /sbin/shutdown -r now
fi
