#!/bin/bash
apt-get update
apt-get -y install wget curl nano
sed -i "s/#DNSStubListener=yes/DNSStubListener=no/g" /etc/systemd/resolved.conf && \
systemctl restart systemd-resolved
