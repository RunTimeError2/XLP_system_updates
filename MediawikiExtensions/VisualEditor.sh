#! /bin/bash

# For mediawiki 1.31
echo 'Downloading extension...'
wget https://extdist.wmflabs.org/dist/extensions/VisualEditor-REL1_31-6854ea0.tar.gz
echo 'Extracting extension...'
tar -xzf VisualEditor-REL1_31-6854ea0.tar.gz -C /data/xlpsystem/mediawiki_dev/extensions/
chmod -R 777 /data/xlpsystem/mediawiki_dev/extensions/VisualEditor
rm VisualEditor-REL1_31-6854ea0.tar.gz

conf_str=`grep 'wfLoadExtension( 'VisualEditor' );' /data/xlpsystem/mediawiki/LocalSettings.php`
if [ -z "$conf_str" ]; then
    echo 'Configuration not written yet, writing to LocalSettings.php ...'
	echo '' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "wfLoadExtension( 'VisualEditor' );" >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "$wgDefaultUserOptions['visualeditor-enable'] = 1;" >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "$wgHiddenPrefs[] = 'visualeditor-enable';" >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo '$wgVisualEditorAvailableNamespaces = [' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo '    "Help" => false,' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo '    "Extra" => true' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo '];' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "$wgVirtualRestConfig['modules']['parsoid'] = array(" >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo '    "url" => "http://parsoid:8000",' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo '    "domain" => "localhost",' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo '    "prefix" => "localhost"' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo ');' >> /data/xlpsystem/mediawiki/LocalSettings.php
fi

if [ -n "$conf_str" ]; then
    echo 'Configuration already written to LocalSettings.php.'
fi

echo 'Installation completed. You should also check the docker-compose.yml file and make sure that container for Parsoid is already launched.'
