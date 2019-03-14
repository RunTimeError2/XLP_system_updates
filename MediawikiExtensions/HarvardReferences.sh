#! /bin/bash

# For mediawiki 1.31
echo 'Installing extension...'
mkdir /data/xlpsystem/mediawiki_dev/extensions/HarvardReferences
cp HarvardReferences.php /data/xlpsystem/mediawiki_dev/extensions/HarvardReferences/HarvardReferences.php
chmod -R 777 /data/xlpsystem/mediawiki_dev/extensions/HarvardReferences

conf_str=`grep 'wfLoadExtension( 'HarvardReferences' );' /data/xlpsystem/mediawiki/LocalSettings.php`
if [ -z "$conf_str" ]; then
    echo 'Configuration not written yet, writing to LocalSettings.php ...'
    echo '' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "wfLoadExtension( 'HarvardReferences' );" >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "$wgHarvardReferencesOn = true;" >> /data/xlpsystem/mediawiki/LocalSettings.php
fi

if [ -n "$conf_str" ]; then
    echo 'Configuration already written to LocalSettings.php.'
fi

echo 'Installation completed.'
