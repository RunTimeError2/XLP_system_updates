#! /bin/bash

repo_url='https://github.com/RunTimeError2/XLP_landingpage.git'

which nginx
if [ $? -ne 0 ]; then
	echo 'Nginx not installed yet. Installing nginx...'
	apt-get install nginx
else
	echo 'Nginx already installed.'
fi

echo 'Cloning repository...'
mkdir /var/www
git clone ${repo_url} /var/www/

echo 'Copying configuration...'
cp /var/www/XLP_landingpage/XLP_landingpage.conf /etc/nginx/sites-available/default

echo 'Enabling landingpage...'
service nginx restart

echo 'Landing page deployed. Please edit file /etc/nginx/sites-available/default and write ip address of this machine.'
