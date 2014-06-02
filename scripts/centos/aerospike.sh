#!/bin/bash

#rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
yum -y install python-pip
yum -y install python-devel
mkdir /tmp/aero
cd /tmp/aero
sudo yum -y install wget
wget 'http://iss0/release/server/3.3.2/centos6/aerospike-server-community-3.3.2-el6.tgz' 
tar xzf aerospike-server-community-3.3.2-el6.tgz 
cd aerospike-server-community-3.3.2-el6 
rpm -ivh aerospike-*
sudo pip install markupsafe
sudo pip install paramiko
sudo pip install ecdsa
sudo pip install pycrypto
yum install ansible -y
cd /tmp/aero
wget 'http://aerospike.com/amc/3.3.1/aerospike-management-console-3.3.1-el5.x86_64.rpm'
rpm -ivf aerospike-management-console-3.3.1-el5.x86_64.rpm
rm -rf /tmp/aero/*
sudo chkconfig --add aerospike
