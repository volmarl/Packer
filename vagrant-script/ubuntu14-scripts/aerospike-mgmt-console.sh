#!/bin/bash

echo -------- Installing Aerospike Management Console ----------------
apt-get -y install python-pip python-dev ansible
pip install markupsafe paramiko ecdsa pycrypto

cd /tmp/aero
wget -qO amc.deb 'http://aerospike.com/amc/3.3.1/aerospike-management-console-3.3.1.all.x86_64.deb'
dpkg -i amc.deb
service amc start #start amc now