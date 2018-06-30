#!/usr/bin/env bash

sudo apt-get update

# Install MySQL

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password secret'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password secret'
sudo apt-get install -y mysql-server-5.6

#
# Configure MySQL Remote Access
#
MYSQLAUTH="--user=root --password=secret"
mysql $MYSQLAUTH -e "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql $MYSQLAUTH -e "CREATE USER 'magento'@'localhost' IDENTIFIED BY 'secret';"
mysql $MYSQLAUTH -e "GRANT ALL ON *.* TO 'magento'@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql $MYSQLAUTH -e "GRANT ALL ON *.* TO 'magento'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql $MYSQLAUTH -e "FLUSH PRIVILEGES;"
mysql $MYSQLAUTH -e "CREATE DATABASE magento;"

# Install Apache and PHP
sudo apt-get -y update
sudo add-apt-repository ppa:ondrej/php
sudo apt-get -y update
sudo apt-get -y install php7.0 php7.0-mcrypt php7.0-mbstring php7.0-curl php7.0-cli php7.0-mysql php7.0-gd php7.0-intl php7.0-xsl php7.0-zip php7.0-bcmath php7.0-soap git

# Install Composer.
cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo cp composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Environment variables from /etc/apache2/apache2.conf
#export APACHE_RUN_USER=www-data
#export APACHE_RUN_GROUP=www-data
#export APACHE_RUN_DIR=/var/run/apache2
#export APACHE_LOG_DIR=/var/log/apache2
#export APACHE_LOCK_DIR=/var/lock/apache2
#export APACHE_PID_FILE=/var/run/apache2/apache2.pid

# Enable Apache rewrite module
sudo a2enmod rewrite

# Remove default Apache config - we supply our own for Magento.
sudo rm -f /etc/apache2/sites-enabled/000-default.conf
#sudo a2dissite 000-default


# Add the Apache virtual host file
sudo cp /vagrant/config/apache_default_vhost /etc/apache2/sites-enabled/magento2.conf
sudo apache2ctl restart
