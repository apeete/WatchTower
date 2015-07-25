#!/usr/bin/env bash

echo "Setting up new virtual machine..."

echo "Installing Git"
apt-get install git -y

echo "Installing Apache"
apt-get install apache2 -y
if ! [ -L /var/www/ ]; then
  rm -rf /var/www
  mkdir /var/www
  ln -fs /vagrant/ /var/www/
fi

apt-get install libapache2-mod-php5 -y
service apache2 restart

echo "Updating PHP Repository"
apt-get install python-software-properties build-essential -y
add-apt-repository ppa:ondrej/php5 -y
apt-get update

echo "Installing PHP"
apt-get install php5-common php5-dev php5-cli php5-fpm -y

echo "Installing PHP extensions"
apt-get install curl php-soap php5-curl php5-gd php5-mcrypt php5-mysql php5-intl -y

echo "Installing oAuth"
service apache2 stop
pear config-set php_ini /etc/php5/apache2/php.ini
pecl config-set php_ini /etc/php5/apache2/php.ini
pecl install oauth
service apache2 start

echo "Installing MySQL"
apt-get install debconf-utils -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y mysql-server

echo "Installing CodeSniffer"
pear install PHP_CodeSniffer

echo "Installing PHPDocumentor"
pear channel-discover pear.phpdoc.org
pear install phpdoc/phpDocumentor

echo "Installing GraphViz"
apt-get install graphviz -y
