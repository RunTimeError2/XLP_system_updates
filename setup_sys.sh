#! /bin/bash

# Automatically install XLP system

# Global configuration
# Whether to start rsync daemon
launch_rsync=0
# Nexus proxy repository for official images
nexus_host_proxy='192.168.1.103:8083'
# Nexus hosted repository for self-made images
nexus_host_hosted='192.168.1.103:8082'
# Account for Nexus
nexus_username='admin'
nexus_password='admin123'
# IP of server where data are stored
server_ip='3.0.55.85'

echo 'Please make sure that you have correctly added --insecure-registry configuration for docker.'
echo 'Installation will start in 10 seconds, please quit if --insecure-registry is not configured.'
sleep 10s

echo 'Restarting docker...'
systemctl daemon-reload
systemctl restart docker

echo 'Logining in to nexus server...'
docker login -u ${nexus_username} -p ${nexus_password} ${nexus_host_hosted}
docker login -u ${nexus_username} -p ${nexus_password} ${nexus_host_proxy}

if [ ${launch_rsync} -ne 0 ]; then
	echo 'Starting rsync daemon...'
	rsync --daemon --config=/etc/rsyncd.config
else
	echo 'Rsync daemon will not be started.'
fi

echo 'Environment successfully established.'

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
docker pull ${nexus_host_hosted}/xlpmediawiki_2019:0402

docker tag ${nexus_host_proxy}/xlpsystem/wordpress:20180820185725 xlpsystem/wordpress:20180820185725
docker tag ${nexus_host_proxy}/xlpsystem/matomo:20180820163542 xlpsystem/matomo:20180820163542
docker tag ${nexus_host_proxy}/xlpsystem/elasticsearch:20180822142218 xlpsystem/elasticsearch:20180822142218
docker tag ${nexus_host_proxy}/xlpsystem/kibana:20180821233221 xlpsystem/kibana:20180821233221
docker tag ${nexus_host_proxy}/mysql:5.7.14 mysql:5.7.14
docker tag ${nexus_host_proxy}/redpointgames/phabricator redpointgames/phabricator
docker tag ${nexus_host_proxy}/thenets/parsoid:0.9.0 thenets/parsoid:0.9.0
docker tag ${nexus_host_hosted}/logstash/logstash-oss:6.6.1 docker.elastic.co/logstash/logstash-oss:6.6.1
docker tag ${nexus_host_hosted}/xlpmariadb_2019:0402 mariadb:10.3
docker tag ${nexus_host_hosted}/xlpmediawiki_2019:0402 xlpsystem/mediawiki:20180827140844

# Pull data via rsync
echo 'Pulling data from server...'
rsync -vazu --progress --delete root@${server_ip}::xlpdata /data/xlpsystem/ --password-file=/data/pw.passwd
# rm -r /data/xlpsystem/elasticsearch
chmod -R 777 /data/xlpsystem

# Starting containers
echo 'Launching containers...'
docker-compose -f full_conf.yml up -d

# Install TeamViewer
echo 'Installing TeamViewer...'
apt install gdebi-core
gdebi teamviewer_14.2.2558_amd64.deb

echo 'Done.'
