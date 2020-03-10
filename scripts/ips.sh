#!/bin/sh

# This script displays VPN status, server, server type, and IP Address
# Depends on `bind-tools` and `protonvpn-cli-ng`

# Author: Piotr Miller
# e-mail: nwg.piotr@gmail.com
# Website: http://nwg.pl
# Project: https://github.com/nwg-piotr/tint2-executors
# License: GPL3
# Modified by: Phate6660 (https://github.com/Phate6660)

i="$(dig +short myip.opendns.com @resolver1.opendns.com)"
if protonvpn s | grep Disconnected; then
    output="| VPN: OFF | $i |"
else
    s="$(protonvpn s | sed -n 4p | awk -F\  '{ print $2 }')"
    f="$(protonvpn s | sed -n 5p | awk -F\  '{ print $2 }')"
    case $f in
        "Normal") f="Norm";;
        "P2P");;
        "Tor");;
        "Secure-Core") f="Sec";;
        *) f="?";;
    esac
    output="VPN: ON ($s - $f) | $i"
fi
echo "$output"
