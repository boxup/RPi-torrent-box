sudo vi /home/pi/.config/transmission-daemon/settings.json

sed -c -i "s/\($TARGET_KEY *= *\).*/\1$REPLACEMENT_VALUE/" $CONFIG_FILE
ls -la /var/www/ | grep "\->"

/usr/bin/transmission-daemon
/lib/systemd/system/transmission-daemon.service


ls -la /usr/bin/ | grep "daemon \->"

rm -f /home/pi/.config/transmission-daemon/settings.json
ln -s /etc/transmission-daemon/settings.json /home/pi/.config/transmission-daemon/settings.json


lrwxrwxrwx 1 pi pi   38 Dec 23 03:25 settings.json -> /etc/transmission-daemon/settings.json


/home/pi/.config/transmission-daemon/settings.json

edited permissions
-rw-r--r-- 1 pi pi 2295 Dec 23 04:00 /etc/transmission-daemon/settings.json
-rw-r--r-- 1 pi pi 1934 Dec 23 04:00 /etc/init.d/transmission-daemon
-rw-r--r-- 1 root root 231 Dec 23 04:00 /etc/systemd/system/multi-user.target.wants/transmission-daemon.service

original permissions
-rw------- 1 debian-transmission debian-transmission 2384 Dec 23 04:08 /etc/transmission-daemon/settings.json
-rw-r--r-- 1 root root 231 Dec 23 04:00 /etc/systemd/system/multi-user.target.wants/transmission-daemon.service
-rw-r--r-- 1 root root 231 Dec 23 04:00 /etc/systemd/system/multi-user.target.wants/transmission-daemon.service
