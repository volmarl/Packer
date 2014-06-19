#!/bin/bash

#centos65 or ubuntu14
platform=$1
here=`pwd`

echo Provisioning for platform: $platform

mkdir /tmp/aero
cd /tmp/aero

source $here/${platform}-scripts/preconfig.sh
source $here/${platform}-scripts/aerospike-server.sh
source $here/${platform}-scripts/aerospike-mgmt-console.sh
source $here/${platform}-scripts/nodejs-client.sh

echo -------- Clean up ----------------
rm -rf /tmp/aero/*
