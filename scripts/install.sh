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
sudo apt-get install -y apache2 php5 php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-xsl curl git

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

# mcrypt.ini appears to be missing from apt-get install. Needed for PHP mcrypt library to be enabled.
sudo cp /vagrant/config/20-mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini
sudo cp /vagrant/config/20-mcrypt.ini /etc/php5/apache2/conf.d/20-mcrypt.ini

# Add the Apache virtual host file
sudo cp /vagrant/config/apache_default_vhost /etc/apache2/sites-enabled/magento2.conf
sudo apache2ctl restart
