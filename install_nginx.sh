#!/bin/bash
apt-get install nginx pwgen -y
ln -s /var/www/html/index.nginx-debian.html /var/www/html/index.html
pwgen 25600 > /var/www/html/25
pwgen 51200 > /var/www/html/50
pwgen 76800 > /var/www/html/75
pwgen 102400 > /var/www/html/100
pwgen 256000 > /var/www/html/250