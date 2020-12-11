#!/bin/bash

# Start MySQL php-fpm and nginx
/etc/init.d/mysql start
/etc/init.d/php7.3-fpm start
/etc/init.d/nginx start

# Authorize access for NGINX user
chown -R www-data:www-data /var/www/*
chmod -R 777 /var/www/*

# Create website
cp srcs/ft_server.conf /etc/nginx/sites-available/ft_server
ln -s /etc/nginx/sites-available/ft_server /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Create root folder for website
mkdir /var/www/ft_server
echo "<?php phpinfo(); ?>" >> /var/www/ft_server/index.php
cp srcs/index.html /var/www/ft_server/index.html

# Generate SSL key and certificate
mkdir /var/www/ft_server/ssl
openssl req -nodes -subj '/CN=localhost' -x509 -newkey rsa:4096 -keyout /var/www/ft_server/ssl/key.pem -out /var/www/ft_server/ssl/cert.pem -days 365

# Download phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
mv phpMyAdmin-4.9.0.1-all-languages /var/www/ft_server/phpmyadmin
# Configure phpMyAdmin (AllowNoPassword = true)
cp -pr srcs/config.inc.php /var/www/ft_server/phpmyadmin/config.inc.php

# Dowload Wordpress
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz -C /var/www/ft_server
cp srcs/wp-config.php /var/www/ft_server/wordpress

# Configure mySQL database and user
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "CREATE USER 'mamartin'@'localhost';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'mamartin'@'localhost' WITH GRANT OPTION;" | mysql -u root
echo "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'mamartin';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root
echo "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# Restart php-fpm and nginx
/etc/init.d/php7.3-fpm restart
/etc/init.d/nginx restart

# Keep the container running
while true;
	do sleep 10000;
done