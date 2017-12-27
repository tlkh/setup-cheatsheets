# Quick Setup for LEMP
**L**inux/**N**ginx/**m**ysql/**P**HP

Light and fast stack for Wordpress on constrained platforms such as SBCs (Raspberry Pi) or your $5 VPS.

## Before We Start

`sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y`

`sudo apt-get autoremove`

`sudo apt-get install php7.0 php7.0-curl php7.0-gd`

`sudo apt-get install php7.0-fpm php7.0-cli php7.0-opcache php7.0-mbstring php7.0-xml php7.0-zip`

## PHP Configuration

`sudo nano /etc/php/7.0/fpm/pool.d/www.conf`

Edit the following lines:

```
user = pi
group = pi
```
(Press `CTRL-X` to save)
## Install Nginx

`sudo apt-get install nginx -y`

## Nginx Configuration

`sudo nano /etc/nginx/sites-available/SITE_NAME`

Paste the following contents in:

```
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
```

Now Nginx is configured properly for LEMP. 

## Enabling Nginx

`cd /etc/nginx/sites-enabled/`

`sudo rm default`

`sudo ln -s ../sites-available/SITE_NAME`

`cd ~`

`mkdir www`

`cd www`

Now you have your web directory, `/home/pi/www` for example. Now's the time to make sure we have also gotten rid of Apache.

`sudo service apache2 stop`

`sudo apt-get purge apache2 apache2-utils apache2.2-bin apache2-common`

`nano ~/www/info.php`

Add in the following lines:

```
<?php phpinfo(); ?>
```

Navigate to your device's IP address to see the PHP info page. If you don't see anything, try rebooting: `sudo reboot`

## Installing mysql

`sudo apt-get install mysql-server php7.0-fpm php7.0-mysql phpmyadmin`

`sudo apt-get install libmysqlclient-dev`

Now would be a good time to reboot (just to be safe): `sudo reboot`

## Configuring phpMyAdmin

`sudo nano /etc/nginx/sites-available/your_site`

Add the following lines to the end:
(Quick tip: press `CTRL-V` to skip down a full screen.)

```
### PHPMYADMIN START ###
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
### PHPMYADMIN END ###
```
phpMyAdmin will be accesible on port 6969

### Trouble logging in via phpMyAdmin?

`sudo mysql -u root -p`

In the mysql console:

`CREATE USER 'your_id'@'localhost' IDENTIFIED BY 'yourPassword';`

`GRANT ALL PRIVILEGES ON *.* TO 'your_id'@'localhost';`

`FLUSH PRIVILEGES;`
