#!/bin/bash
apt-get install nginx pwgen zip -y
mkdir /var/www/html/child
pwgen 1024 > /var/www/html/child/random.txt
mkdir /var/www/html/child/grandchild
pwgen 2048 > /var/www/html/child/grandchild/random.txt
zip /var/www/html/random_text_files.zip /var/www/html/child/random.txt /var/www/html/child/grandchild/random.txt