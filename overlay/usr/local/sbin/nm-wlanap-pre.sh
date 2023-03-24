#!/bin/bash
## Generate a unique SSID for nmconnection file
set -eou pipefail

set +e # intentionally always succeed

FILE=/etc/NetworkManager/system-connections/wlanap.nmconnection
CHARS=6

cpuSerial=$(cat /sys/devices/soc0/serial_number)
postfix=${cpuSerial: -$CHARS}

echo -e "Setting hotspot SSID to 'cit-one-$postfix'"
sed -i "s/ssid.*/ssid=cit-one-$postfix/g" $FILE
