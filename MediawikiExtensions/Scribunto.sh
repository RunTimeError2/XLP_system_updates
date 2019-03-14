#! /bin/bash

# For mediawiki 1.31
echo 'Downloading extension...'
wget https://extdist.wmflabs.org/dist/extensions/Scribunto-REL1_31-106fbf4.tar.gz
echo 'Extracting extension...'
tar -xzf Scribunto-REL1_31-106fbf4.tar.gz -C /data/xlpsystem/mediawiki_dev/extensions/
chmod -R 777 /data/xlpsystem/mediawiki_dev/extensions/Scribunto
rm Scribunto-REL1_31-106fbf4.tar.gz

conf_str=`grep 'wfLoadExtension( 'Scribunto' );' /data/xlpsystem/mediawiki/LocalSettings.php`
if [ -z "$conf_str" ]; then
    echo 'Configuration not written yet, writing to LocalSettings.php ...'
    echo '' >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "wfLoadExtension( 'Scribunto' );" >> /data/xlpsystem/mediawiki/LocalSettings.php
	echo "$wgScribuntoDefaultEngine = 'luastandalone';" >> /data/xlpsystem/mediawiki/LocalSettings.php
	# Set type to httpd_sys_script_exec_t if SELinux is enforced:
	#chcon -R -t httpd_sys_script_exec_t /data/xlpsystem/mediawiki_dev/extensions/Scribunto/includes/engines/LuaStandalone/binaries
fi

if [ -n "$conf_str" ]; then
    echo 'Configuration already written to LocalSettings.php.'
fi

echo 'Installation completed.'
