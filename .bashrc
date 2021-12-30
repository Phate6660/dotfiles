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
# - Nano
# - NVim
# Created by: https://github.com/Phate6660

# Do nothing of not interactive
if [[ $- != *i* ]]; then
    return
fi

## Functions
# Search for a running process. Example: `psg firefox`
psg() {
    # shellcheck disable=SC2009
    ps auxfww | grep -v grep | grep -i -e VSZ -e "$1"
}

# Obtain the weather in your terminal. Change [REDACTED] to either your town, zip code, coordinates, or IP Address
wttr() {
    local request="wttr.in/${1-[REDACTED]?u}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "${request}"
}

# Reconnect to protonvpn
pvre() {
    sudo protonvpn d
    sudo protonvpn c -f
    sudo protonvpn s
}

# Connect to a P2P server in protonvpn
pvp2p() {
    sudo protonvpn d
    sudo protonvpn c --p2p
    sudo protonvpn s
}

# Compare 2 directories for differences. There will be no output if both directories are identical. Includes subdirectories too.
# Example: atts $HOME/example $HOME/example2
diffdir() { diff -r -q "$@"; }

# How much music. Example output:
# You have:
# ---------
# 172 artists.
# 1113 albums.
# 11306 songs.
# 17107 files.
#
# Which uses up 232GB of storage.
# Also, you have played 46937 complete songs since the end of March 2019.
#
# Now playing: Seamless by American Head Charge
# ====================================================
# Note: You may need to change some things, like the music directory and the libre.fm user url.
hmm() {
    artists="$(mpc list Artist | sed '/^\s*$/d' | wc -l) artists."
    albums="$(mpc list Album | sed '/^\s*$/d' | wc -l) albums."
    songs="$(mpc list Title | sed '/^\s*$/d' | wc -l) songs."
    files="$(tree -a "${MUSIC}" | tail -n1 | awk -F\  '{print $3}') files."
    size="Which uses up $(\du -hs /mnt/ehdd2/Music | cut -c 1-4)B of storage."
    amount="Also, you have played $(w3m -dump https://libre.fm/user/phate6660/stats | grep Total | sed "s/[^0-9]//g") complete songs since the end of March 2019."
    status="$(w3m -dump https://libre.fm/user/phate6660/ | grep "playing" | sed 's/×\ //g')"
    echo -e "\nYou have:\n---------\n${artists}\n${albums}\n${songs}\n${files}\n\n${size}\n${amount}\n\n${status}\n"
}

do_all() {
    sudo emerge --sync
    sudo emerge -avuDN --with-bdeps=y @world
    sudo emerge -Dac
}

# Update Gentoo
port() {
    local operation="${1}"
    if [ -z "${operation}" ]; then
        do_all
    else
        case "${operation}" in
            # Sync repositories and pipe into less for easy reading of the output
            "sync") sudo emerge --sync;;                      
            # Update packages
            "date") sudo emerge -avuDN --with-bdeps y @world;;
            # Remove any unnecessary packages
            "clean") sudo emerge -Dac;;
            # Rebuild any packages that need it (such as important library updates, etc)
            "rebuild") sudo revdep-rebuild -i;;
        esac
    fi
    # shellcheck disable=SC2162
    read -p "Your system has been updated. Press [ENTER] to continue."
}

# Notify When Done
# usage: nwd COMMAND
# Runs COMMAND and sends a notification when finished.
nwd() {
    local COMMAND="$*"
    eval "${COMMAND}"
    notify-send "$ ${COMMAND}" "Your command is finished."
}

# Quality of life alias for using the unofficial (but still awesome) Rust rewrites of GNU Coreutils
uu() {
    coreutils "$@"
}

# Neatly output contents of $PATH
lspath() {
    echo -e "${PATH//\:/\\n}"
}

# Set the wallpaper by choosing a random wallpaper
# recursively in the set directory, and on the set monitor (starts at 0).
# Example: `wall /mnt/ehdd/Pictures/wallpapers/ 0`
wall() {
    local set="${1}"
    wallpaper_dir="/mnt/ehdd/Pictures/wallpapers"
    if [ "${set}" == "both"  ]; then
        printf "Setting wallpaper on both monitors.\n"
        feh --bg-fill -d -r -z "${wallpaper_dir}"
    else
        printf "Setting wallpaper to span across all monitors.\n"
        feh --bg-scale --no-xinerama -d -r -z "${wallpaper_dir}"
    fi
}

## General Stuff
# check and change (if needed) window size after every command finishes
shopt -s checkwinsize

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Enable extglob, used for (as the name suggests), extending features and support for globbing
shopt -s extglob

# Prompt example (you can't tell in here, but there is color):
# [11:21 PM]-[Tue Dec 10]
# [valley@gentoo]
# [~]-[0]->
# shellcheck disable=SC2155
export PS1="\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;99m\]\@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\d\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;118m\]\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;69m\]\h\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;244m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;15m\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\$?\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;226m\]> \[$(tput sgr0)\]"

# Set the PATH
export PATH="${HOME}/.cargo/bin:${HOME}/scripts:${HOME}/.local/bin:${HOME}/.gem/ruby/2.7.0/bin:${PATH}"

# Variables for paths in EHDDs
export EHDD="/mnt/ehdd"
export EHDD2="/mnt/ehdd2"
export ANIME="${EHDD}/Videos/Anime"
export MOVIES="${EHDD}/Videos/Movies"
export MUSIC="${EHDD2}/Music"
export TV="${EHDD}/Videos/TV"

# Enable filtering in mpv bash completion
export _mpv_use_media_globexpr=1

# Enable completions
# shellcheck disable=SC1091
source /etc/bash/bashrc.d/bash_completion.sh
# Completions for github-cli
eval "$(gh completion -s bash)"

# Generate LS_COLORS with vivid
# shellcheck disable=SC2155
export LS_COLORS="$(vivid generate molokai)"

# Color for less
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Set the compiler to GCC/G++ by default
export CC="gcc"
export CXX="g++"

# CMake + other various compilation options
COMMON_FLAGS="-march=ivybridge -O3 -pipe -falign-functions=32"
export CMAKE_GENERATOR="Ninja"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

# Make GPG work
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"

# Set various EDITOR related stuff
export EDITOR="/usr/bin/nvim"
export SUDO_EDITOR="nvim"

# Set XZ to use max compression (-9) and multithread using the number of CPUs (-T0)
export XZ_DEFAULTS="-9 -T0"

## Aliases
# cat -> bat with plain output
alias cat="bat -p --color=always"
# ls -> exa with {
# extended metadata,
# type indicators,
# headers,
# and showing all files
# }
alias ls="exa -lFha --git --color=always"
# ps -> ps with {
# show all processes,
# display user-oriented format,
# show processes that aren't attached to ttys,
# use full-format listing,
# no output truncation
# }
alias ps="ps auxfww"
# mv -> mv with make any necessary parent directories, show verbose output
alias mkdir='mkdir -pv'
# {mv, rm} -> {mv, rm} with interactive and verbose
alias mv="mv -iv" 
alias rm="rm -iv"
# cp -> xcp with verbose and 4 workers (threads)
alias cp="xcp -vw 4"
# grep -> rg
alias grep="rg"
# find -> fd
alias find="fd"
# Display what processes are using ALSA
alias adev="fuser -fv /dev/snd/*"
# View audio stats like bitrate and samplerate of audio currently playing in ALSA
alias astat="cat /proc/asound/card0/pcm0p/sub0/hw_params"
# View volume for ALSA
# shellcheck disable=SC2142
alias avol="awk -F\"[][]\" '/dB/ { print \$2 }' <(amixer sget Master)"
# Set the keyboard rate | TODO: remember what those numbers mean so I can explain it
alias setr="xset r rate 200 60"
# ss -> ss with {
# no service names,
# only tcp sockets,
# displaying listening sockets,
# and showing processes using sockets
# }
alias ss="ss -ntlp"
# Use aria2 with 5 threads and rate each thread to 5M
alias aria="aria2c -c -j5 -x5 -s5 -k 5M"
# Alias to cure my laziness
alias e="nvim"
# rsfetch with options wanted
alias rsfetch="rsfetch -cDdEeghkmMstuUC 0 -p portage"
# View anime collection as a tree, excludes various files through globbing, and extends down 3 levels
alias lsanime="exa -I \
    '*Menu*|*Screen*|*SP*|*CD*|*Sample*|*Extra*|*.jpg|*.png|*.ass|*.srt|*.mp4|*.mkv|*.txt|*.nfo|*.sfv|*.md5|*.mka|*.rar|playlist' \
    -L 3 -T \${ANIME}"
