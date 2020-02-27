#  ██▒   █▓ ▄▄▄       ██▓     ██▓    ▓█████▓██   ██▓
# ▓██░   █▒▒████▄    ▓██▒    ▓██▒    ▓█   ▀ ▒██  ██▒
#  ▓██  █▒░▒██  ▀█▄  ▒██░    ▒██░    ▒███    ▒██ ██░
#   ▒██ █░░░██▄▄▄▄██ ▒██░    ▒██░    ▒▓█  ▄  ░ ▐██▓░
#    ▒▀█░   ▓█   ▓██▒░██████▒░██████▒░▒████▒ ░ ██▒▓░
#    ░ ▐░   ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░░░ ▒░ ░  ██▒▒▒
#    ░ ░░    ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░ ░ ░  ░▓██ ░▒░
#      ░░    ░   ▒     ░ ░     ░ ░      ░   ▒ ▒ ░░
#       ░        ░  ░    ░  ░    ░  ░   ░  ░░ ░
#      ░                                    ░ ░
# This file was made and edited with:
# - Emacs
# - Geany
# - GNU Sed
# - Nano
# - Vim
# Created by: https://github.com/Phate6660

## Functions
update() {
    sudo apt update
    sudo apt upgrade
}

## Aliases
alias install="sudo apt install"
alias rem="sudo apt remove"
alias clean="sudo apt autoremove"
alias searchfor="apt search"