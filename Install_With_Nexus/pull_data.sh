#! /bin/bash

# Pulling data of Mediawiki, Matomo, MariaDB
# Data of Elasticsearch can be deleted
server_ip='3.0.55.85'

rsync -vazu --delete root@${server_ip}::xlpdata /data/xlpsystem/ --password-file=/data/pw.passwd

# rm -r /data/xlpsystem/elasticsearch
chmod -R 777 /data/xlpsystem
