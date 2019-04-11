#! /bin/bash

serverip='3.0.55.85'
typeset -l dirname
dirname=$(basename `pwd`)

rsync -vazu --progress --delete root@${server_ip}::xlpdata /data/xlpsystem/ --password-file=/data/pw.passwd
# rm -r /data/xlpsystem/elasticsearch
chmod -R 777 /data/xlpsystem

docker exec -u root ${dirname}_mediawiki_1 php /var/www/html/maintenance/update.php --quick
