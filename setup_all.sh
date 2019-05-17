#1 /bin/bash

# Nexus proxy repository for official images
nexus_host_proxy='192.168.1.103:8083'
# Nexus hosted repository for self-made images
nexus_host_hosted='192.168.1.103:8082'
# Account for Nexus
nexus_username='admin'
nexus_password='admin123'
# IP of server where data are stored
server_ip='192.168.1.131'

echo 'Setting up environment...'

echo 'Changing source for apt-get...'
wget http://192.168.1.131/sources.list
mv /etc/apt/sources.list /etc/apt/sources.list.bak
mv sources.list /etc/apt/

echo 'Updating source for apt-get...'
apt-get update

which docker
if [ $? -ne 0 ]; then
	echo 'Docker not installed yet. Installing docker...'
	apt-get install docker.io -y
else
	echo 'Docker already installed.'
fi

which pip
if [ $? -ne 0 ]; then
	echo 'pip not installed yet. Installing pip...'
	apt-get install python-pip -y
else
	echo 'pip already installed.'
fi

which docker-compose
if [ $? -ne 0 ]; then
	echo 'Docker-compose not installed yet. Installing docker-compose...'
	pip install docker-compose
else
	echo 'Docker-compose already installed.'
fi

which nginx
if [ $? -ne 0 ]; then
	echo 'Nginx not installed yet. Installing nginx...'
	apt-get install nginx -y
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
chmod 600 /data/pw.passwd
chmod 600 /data/pw.password
cp rsync/rsyncd.conf /etc/rsyncd.conf

echo 'Starting rsync daemon...'
rsync --daemon --config=/etc/rsyncd.config

echo 'Environment successfully established.'

echo 'Configurating docker...'
mv /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
cp -f docker.service /lib/systemd/system/
systemctl daemon-reload
systemctl restart docker

echo 'Logining in to nexus server...'
docker login -u ${nexus_username} -p ${nexus_password} ${nexus_host_hosted}
docker login -u ${nexus_username} -p ${nexus_password} ${nexus_host_proxy}

# Pull docker images from Nexus server
docker pull ${nexus_host_proxy}/xlpsystem/wordpress:20180820185725
docker pull ${nexus_host_proxy}/xlpsystem/matomo:20180820163542
docker pull ${nexus_host_proxy}/xlpsystem/elasticsearch:20180822142218
docker pull ${nexus_host_proxy}/xlpsystem/kibana:20180821233221
docker pull ${nexus_host_proxy}/mysql:5.7.14
docker pull ${nexus_host_proxy}/redpointgames/phabricator
docker pull ${nexus_host_proxy}/thenets/parsoid:0.9.0
docker pull ${nexus_host_hosted}/logstash/logstash-oss:6.6.1
docker pull ${nexus_host_hosted}/xlpmariadb_2019:0402
#docker pull ${nexus_host_hosted}/xlpmediawiki_2019:0402
docker pull ${nexus_host_hosted}/mediawiki:20190516

docker tag ${nexus_host_proxy}/xlpsystem/wordpress:20180820185725 xlpsystem/wordpress:20180820185725
docker tag ${nexus_host_proxy}/xlpsystem/matomo:20180820163542 xlpsystem/matomo:20180820163542
docker tag ${nexus_host_proxy}/xlpsystem/elasticsearch:20180822142218 xlpsystem/elasticsearch:20180822142218
docker tag ${nexus_host_proxy}/xlpsystem/kibana:20180821233221 xlpsystem/kibana:20180821233221
docker tag ${nexus_host_proxy}/mysql:5.7.14 mysql:5.7.14
docker tag ${nexus_host_proxy}/redpointgames/phabricator redpointgames/phabricator
docker tag ${nexus_host_proxy}/thenets/parsoid:0.9.0 thenets/parsoid:0.9.0
docker tag ${nexus_host_hosted}/logstash/logstash-oss:6.6.1 docker.elastic.co/logstash/logstash-oss:6.6.1
docker tag ${nexus_host_hosted}/xlpmariadb_2019:0402 mariadb:10.3
#docker tag ${nexus_host_hosted}/xlpmediawiki_2019:0402 xlpsystem/mediawiki:20180827140844
docker tag ${nexus_host_hosted}/mediawiki:20190516 mediawiki:20190516

# Pull data via rsync
echo 'Pulling data from server...'
rsync -vazu --progress --delete root@${server_ip}::xlpdata /data/xlpsystem/ --password-file=/data/pw.passwd
# rm -r /data/xlpsystem/elasticsearch
chmod -R 777 /data/xlpsystem
echo 'Replacing configuration...'
mv -f /data/xlpsystem/LocalSettings.php /data/xlpsystem/mediawiki/LocalSettings.php
mv -f /data/xlpsystem/config.ini.php /data/xlpsystem/matomo/config/config.ini.php

# Edit hosts
echo 'Editing hosts'
sed -i '1i\127.0.0.1   vm.xlp.pub' /etc/hosts

# Install TeamViewer
echo 'Installing TeamViewer...'
apt install gdebi-core
gdebi teamviewer_14.2.2558_amd64.deb

# Starting containers
echo 'Launching all containers...'
docker-compose -f full_conf.yml up -d
#docker-compose -f basic_setup.yml up -d

# Installing Landing page
wget http://192.168.1.103/landingpage.tar.gz
tar -zxvf landingpage.tar.gz
cp -r XLP_landingpage /var/www/
cp -f /var/www/XLP_landingpage/XLP_landingpage.conf /etc/nginx/sites-available/default
service nginx restart

# Switching back the apt-source
#rm /etc/apt/sources.list
#mv /etc/apt/sources.list.bak /etc/apt/sources.list
#apt-get update
echo 'Awaiting containers...'
sleep 30s

echo 'Done.'
