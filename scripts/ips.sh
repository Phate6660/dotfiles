#!/bin/sh

# This script display external and internal IP address in two rows
# Depends on `bind-tools` and `protonvpn` (https://github.com/ProtonVPN/protonvpn-cli-ng)

# Author: Piotr Miller
# e-mail: nwg.piotr@gmail.com
# Website: http://nwg.pl
# Project: https://github.com/nwg-piotr/tint2-executors
# License: GPL3
# Modified by: Phate6660 (https://github.com/Phate6660)

w="$(dig +short myip.opendns.com @resolver1.opendns.com)"
# Replace [REDACTED] with your typical IP when the VPN is off.
if [ "$w" = "[REDACTED]" ]; then
    output="| VPN: OFF | $w |"
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
    output="| VPN: ON ($s - $f) | $w |"
fi
echo "$output"
