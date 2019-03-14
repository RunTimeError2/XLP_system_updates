#! /bin/bash

# For mediawiki 1.31
echo 'Downloading extension...'
wget https://extdist.wmflabs.org/dist/extensions/Cite-REL1_31-20e26df.tar.gz
echo 'Extracting extension...'
tar -xzf Cite-REL1_31-20e26df.tar.gz -C /data/xlpsystem/mediawiki_dev/extensions/
chmod -R 777 /data/xlpsystem/mediawiki_dev/extensions/Cite
rm Cite-REL1_31-20e26df.tar.gz

conf_str=`grep 'wfLoadExtension( 'Cite' );' /data/xlpsystem/mediawiki/LocalSettings.php`
if [ -z "$conf_str" ]; then
    echo 'Configuration not written yet, writing to LocalSettings.php ...'
    echo '' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "wfLoadExtension( 'Cite' );" >> /data/xlpsystem/mediawiki/LocalSettings.php
fi

if [ -n "$conf_str" ]; then
    echo 'Configuration already written to LocalSettings.php.'
fi

echo 'Installation completed.'
