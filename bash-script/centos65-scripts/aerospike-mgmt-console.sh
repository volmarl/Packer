#!/bin/bash

echo -------- Installing Aerospike Management Console ----------------
yum -y install python-pip python-devel ansible
pip install markupsafe paramiko ecdsa pycrypto

cd /tmp/aero
wget -qO amc.rpm 'http://aerospike.com/amc/3.3.1/aerospike-management-console-3.3.1-el5.x86_64.rpm'
rpm -ivf amc.rpm
service amc start #start amc now