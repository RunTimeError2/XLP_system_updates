#! /bin/bash

echo 'Starting rsync daemon...'
rsync --daemon --config=/etc/rsyncd.config
