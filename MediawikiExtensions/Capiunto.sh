#! /bin/bash

# For mediawiki 1.31
echo 'Downloading extension...'
wget https://extdist.wmflabs.org/dist/extensions/Capiunto-REL1_31-cbcd67b.tar.gz
echo 'Extracting extension...'
tar -xzf Capiunto-REL1_31-cbcd67b.tar.gz -C /data/xlpsystem/mediawiki_dev/extensions/
chmod -R 777 /data/xlpsystem/mediawiki_dev/extensions/Capiunto
rm Capiunto-REL1_31-cbcd67b.tar.gz

conf_str=`grep 'wfLoadExtension( 'Capiunto' );' /data/xlpsystem/mediawiki/LocalSettings.php`
if [ -z "$conf_str" ]; then
    echo 'Configuration not written yet, writing to LocalSettings.php ...'
    echo '' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "wfLoadExtension( 'Capiunto' );" >> /data/xlpsystem/mediawiki/LocalSettings.php
fi

if [ -n "$conf_str" ]; then
    echo 'Configuration already written to LocalSettings.php.'
fi

echo 'Installation completed.'
