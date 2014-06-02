#!/bin/bash

apt-get install python-pip -y
apt-get install python2.7-dev -y
apt-get -f install -y
mkdir /tmp/aero
cd /tmp/aero
wget 'http://iss0/release/server/3.3.2/ubuntu12.04/aerospike-server-community-3.3.2-ubuntu12.04.tgz' 
tar xzf aerospike-server-community-3.3.2-ubuntu12.04.tgz 
cd aerospike-server-community-3.3.2-ubuntu12.04 
sudo dpkg -i aerospike-*
sudo apt-get install gcc cpp python-dev libpython-dev -y
apt-get -f install -y
sudo pip install markupsafe
sudo pip install paramiko
sudo pip install ecdsa
sudo pip install pycrypto
sudo apt-get install ansible -y
cd /tmp/aero
wget 'http://aerospike.com/amc/3.3.1/aerospike-management-console-3.3.1.all.x86_64.deb'
sudo dpkg -i aerospike-management-console-3.3.1.all.x86_64.deb
apt-get -f install -y
apt-get update -y
rm -rf /tmp/aero/*
sed -i -e '/^### END INIT INFO.*/a\ [ ! -d /var/run/aerospike ] && mkdir /var/run/aerospike;chmod 0755 /var/run/aerospike' /etc/init.d/aerospike
update-rc.d aerospike defaults
