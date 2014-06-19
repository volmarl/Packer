#!/bin/bash

echo -------- Installing Aerospike Node.js client ----------------
apt-get -y install npm
ln -s /usr/bin/nodejs /usr/bin/node
cd /tmp/aero
wget -qO client.tgz 'https://github.com/aerospike/aerospike-client-nodejs/archive/master.tar.gz'
tar xzf client.tgz 
mv aerospike-client-nodejs* /home/vagrant