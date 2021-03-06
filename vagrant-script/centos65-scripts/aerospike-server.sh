#!/bin/bash

echo -------- Installing Aerospike Database Server ----------------
yum -y install wget
echo starting wget ...
#wget -qO server.tgz 'http://aerospike.com/download/server/latest/artifact/el6'
wget -qO server.tgz 'http://www.aerospike.com/community_downloads/3.2.9/aerospike-community-server-3.2.9-el6.tgz'
tar xzf server.tgz 
rpm -ivh aerospike-community-server-*/aerospike-community-server-*.rpm
service aerospike start #start amc now
chkconfig --add aerospike # start aerospike on boot
