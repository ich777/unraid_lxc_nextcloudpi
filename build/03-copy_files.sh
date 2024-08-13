#!/bin/bash
cd /tmp/build
chmod 755 $(ls -1 /tmp/build/ | grep -v "^[0-9][0-9]-")
cp /tmp/build/runonce.sh /etc/init.d/runonce.sh
