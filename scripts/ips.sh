#!/bin/sh

# This script display external and internal IP address in two rows
# Depends on `bind-tools`

# Author: Piotr Miller
# e-mail: nwg.piotr@gmail.com
# Website: http://nwg.pl
# Project: https://github.com/nwg-piotr/tint2-executors
# License: GPL3

w=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo "$w"
