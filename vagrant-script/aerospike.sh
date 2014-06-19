#!/bin/bash

#centos65 or ubuntu14
platform=$1
echo Provisioning for platform: $platform

mkdir /tmp/aero
cd /tmp/aero

source /vagrant/${platform}-scripts/preconfig.sh
source /vagrant/${platform}-scripts/aerospike-server.sh
source /vagrant/${platform}-scripts/aerospike-mgmt-console.sh
source /vagrant/${platform}-scripts/nodejs-client.sh

echo -------- Clean up ----------------
rm -rf /tmp/aero/*