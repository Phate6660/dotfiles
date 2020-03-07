#!/bin/sh

# This script display external and internal IP address in two rows
# Depends on `bind-tools`

# Author: Piotr Miller
# e-mail: nwg.piotr@gmail.com
# Website: http://nwg.pl
# Project: https://github.com/nwg-piotr/tint2-executors
# License: GPL3

i="$(dig +short myip.opendns.com @resolver1.opendns.com)"
if protonvpn s | grep Disconnected; then
    output="| VPN: OFF | $i |"
else
    s="$(protonvpn s | sed -n 4p | awk -F\  '{ print $2 }')"
    f="$(protonvpn s | sed -n 5p | awk -F\  '{ print $2 }')"
    case $f in
        "Normal") f="N";;
        "P2P") f="P";;
        "Tor") f="T";;
        "Secure-Core") f="SC";;
        *) f="?";;
    esac
    output="VPN: ON ($s - $f) | $i"
fi
echo "$output"
