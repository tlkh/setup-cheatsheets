## perform the usual dance to get up to date

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y
sudo apt-get autoremove

sudo apt-get install php7.0 php7.0-curl php7.0-gd
sudo apt-get install php7.0-fpm php7.0-cli php7.0-opcache php7.0-mbstring php7.0-xml php7.0-zip

sudo nano /etc/php/7.0/fpm/pool.d/www.conf

## edit the following lines:
user = pi
group = pi
## 

sudo apt-get install nginx

## next we will setup nginx config


sudo touch /etc/nginx/sites-available/your_site

sudo nano /etc/nginx/sites-available/your_site

### FILE BEGIN  ###
server {
    #listen 80;
    index index.html index.php;

    ## Begin - Server Info
    root /var/www/html; # !!! Or whatever your path is !!!
    server_name localhost;
    ## End - Server Info

    ## Begin - Index
    # for subfolders, simply adjust:
    # `location /subfolder {`
    # and the rewrite to use `/subfolder/index.php`
    location / {
        try_files $uri $uri/ /index.html /index.php;
    }
    ## End - Index

    ## Begin - PHP
    location ~ \.php$ {
        # Choose either a socket or TCP/IP address
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        # fastcgi_pass 127.0.0.1:9000;

        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
    }
    ## End - PHP

    ## Begin - Security
    # deny all direct access for these folders
    location ~* /(.git|cache|bin|logs|backups|tests)/.*$ { return 403; }
    # deny running scripts inside core system folders
    location ~* /(system|vendor)/.*\.(txt|xml|md|html|yaml|php|pl|py|cgi|twig|sh|bat)$ { return 403; }
    # deny running scripts inside user folder
    location ~* /user/.*\.(txt|md|yaml|php|pl|py|cgi|twig|sh|bat)$ { return 403; }
    # deny access to specific files in the root folder
    location ~ /(LICENSE.txt|composer.lock|composer.json|nginx.conf|web.config|htaccess.txt|\.htaccess) { return 403; }
    ## End - Security
}
### FILE END  ###

cd /etc/nginx/sites-enabled/
sudo rm default
sudo ln -s ../sites-available/survey

cd ~
mkdir www
cd www

(now you have your directory /home/pi/www for example)

sudo service apache2 stop
sudo apt-get purge apache2 apache2-utils apache2.2-bin apache2-common

sudo reboot now

sudo apt-get install mysql-server php7.0-fpm php7.0-mysql
sudo apt-get install libmysqlclient-dev 

sudo reboot now

touch ~/www/info.php
nano ~/www/info.php

## edit the following
<?php phpinfo(); ?>

## navigate to your device's IP address to see the PHP info page

sudo apt-get install phpmyadmin

sudo nano /etc/nginx/sites-available/your_site

# add the following lines to the end:

### START ###
server {
	listen 6969;
	server_name localhost;
	root /usr/share/phpmyadmin;
	index index.php index.html index.htm;
	if (!-e $request_filename) {
		rewrite ˆ/(.+)$ /index.php?url=$1 last;
		break; 
	}
	location ~ .php$ {
		try_files $uri =404;		
		fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
		fastcgi_index index.php;
		 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include /etc/nginx/fastcgi_params;
	} 
}
### END ###


# if you have trouble logging in via phpMyAdmin
sudo mysql -u root -p

CREATE USER 'your_id'@'localhost' IDENTIFIED BY 'yourPassword';
GRANT ALL PRIVILEGES ON *.* TO 'your_id'@'localhost';
FLUSH PRIVILEGES;