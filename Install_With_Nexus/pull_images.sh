#! /bin/bash

nexus_host_proxy='192.168.1.103:8083'

docker pull ${nexus_host_proxy}/xlpsystem/wordpress:20180820185725
docker pull ${nexus_host_proxy}/xlpsystem/matomo:20180820163542
docker pull ${nexus_host_proxy}/xlpsystem/elasticsearch:20180822142218
docker pull ${nexus_host_proxy}/xlpsystem/kibana:20180821233221
docker pull ${nexus_host_proxy}/mysql:5.7.14
docker pull ${nexus_host_proxy}/redpointgames/phabricator
docker pull ${nexus_host_proxy}/thenets/parsoid:0.9.0
