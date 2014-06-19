#!/bin/bash

echo -------- Installing Aerospike Node.js client ----------------
yum -y install npm
cd /tmp/aero
wget -q 'https://github.com/aerospike/aerospike-client-nodejs/archive/master.tar.gz'
tar xzf master.tar.gz 
mv aerospike-client-nodejs* /home/vagrant