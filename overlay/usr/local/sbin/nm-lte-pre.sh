#!/bin/bash
## Read APN from config file
set -eou pipefail

set +e # intentionally always succeed

FILE=/etc/NetworkManager/system-connections/lte.nmconnection
CONF=/usr/local/etc/lte.conf

source $CONF

echo -e "Setting LTE APN to '$LTE_APN'"
sed -i "s/apn.*/apn=$LTE_APN/g" $FILE
