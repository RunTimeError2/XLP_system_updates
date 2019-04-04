#! /bin/bash

nexus_host_proxy='192.168.1.103:8083'
nexus_host_hosted='192.168.1.103:8082'

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
