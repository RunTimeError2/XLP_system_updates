#! /bin/bash

echo 'Setting up environment...'

echo 'Updating source for apt-get...'
apt-get update

which docker
if [ $? -ne 0 ]; then
	echo 'Docker not installed yet. Installing docker...'
	apt-get install docker.io -y
	if [$? -eq 0]; then
		echo 'Docker successfully installed.'
	else
		echo 'An error occurred when installing docker, please check your system.'
		exit
	fi
else
	echo 'Docker already installed.'
fi

which pip
if [ $? -ne 0 ]; then
	echo 'pip not installed yet. Installing pip...'
	apt-get install python-pip -y
	if [$? -eq 0]; then
		echo 'Pip successfully installed.'
	else
		echo 'An error occurred when installing pip, please check your system.'
		exit
	fi
else
	echo 'pip already installed.'
fi

which docker-compose
if [ $? -ne 0 ]; then
	echo 'Docker-compose not installed yet. Installing docker-compose...'
	pip install docker-compose
	if [$? -eq 0]; then
		echo 'Docker-compose successfully installed.'
	else
		echo 'An error occurred when installing docker-compose, please check your system.'
		exit
	fi
else
	echo 'Docker-compose already installed.'
fi

which nginx
if [$? -ne 0]; then
	echo 'Nginx not installed yet. Installing nginx...'
	apt-get install nginx
	if [$? -eq 0]; then
		echo 'Nginx successfully installed.'
	else
		echo 'An error occurred when installing nginx, please check your system.'
		exit
	fi
else
	echo 'Nginx already installed.'
fi

echo 'Creating working directories...'
mkdir /data
mkdir /data/xlpsystem
chmod -R 777 /data/xlpsystem

echo 'Copying rsync configuration...'
cp rsync/pw.passwd /data/pw.passwd
cp rsync/pw.password /data/pw.password
cp rsync/rsyncd.conf /etc/rsyncd.conf

echo 'Environment successfully established.'