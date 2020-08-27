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

## Check if interactive.
if [[ $- != *i* ]] ; then
	return
fi

## Autostart
# Enable completions
source /etc/bash/bashrc.d/bash_completion.sh
eval "$(gh completion -s bash)"

# McFly
# if [[ -r /home/valley/.mcfly.bash ]]; then
#   source /home/valley/.mcfly.bash
# fi

# check and change (if needed) window size after every command finishes
shopt -s checkwinsize

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

## Environmental Variables
# General
export PATH="$PATH:$HOME/.cargo/bin:$HOME/scripts:$HOME/.local/bin:$HOME/.gem/ruby/2.5.0/bin:$HOME/go/bin"
# Prompt example (you can't tell in here, but there is color):
# [11:21 PM]-[Tue Dec 10]
# [valley@gentoo]
# [~]-[0]->
export PS1="\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;99m\]\@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\d\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;118m\]\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;69m\]\h\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;244m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;15m\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\$?\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;226m\]> \[$(tput sgr0)\]"
export LS_COLORS="$(vivid generate molokai)" # Set LS_COLORS to colors generated by https://github.com/sharkdp/vivid
export EDITOR="/usr/bin/emacsclient"
export SUDO_EDITOR="/usr/bin/emacsclient"
export HISTCONTROL="erasedups:ignoreboth" 
export PASTEL_COLOR_MODE=24bit # For https://github.com/sharkdp/pastel
export GPG_TTY="$(tty)"

# Variables for paths in EHDDs
export ANIME="/mnt/ehdd/Videos/Anime"
export ANIME2="/mnt/ehdd2/Videos/Anime"
export EHDD="/mnt/ehdd"
export EHDD2="/mnt/ehdd2"
export MOVIES="/mnt/ehdd/Videos/Movies"
export MUSIC="/mnt/ehdd2/Music"
export TV="/mnt/ehdd/Videos/TV"

# Color for less
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

## Functions
# Obtain the weather in your terminal. Change [REDACTED] to either your town, zip code, coordinates, or IP Address.
wttr() {
    local request="wttr.in/${1-[REDACTED]?u}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

# How much music. Example output:
# You have:
# ---------
# 147 artists.
# 1070 albums.
# 10923 songs.
# 16781 files.
# 
# Which uses up 219GB of storage.
# Also, you have played 34485 complete songs since the end of March 2019.
# 
# Now playing: World So Cold by Mudvayne
# ====================================================
# Note: You may need to change some things, like the music directory and the libre.fm user url.
hmm() {
    artists="$(mpc list Artist | sed '/^\s*$/d' | wc -l) artists."
    albums="$(mpc list Album | sed '/^\s*$/d' | wc -l) albums."
    songs="$(mpc list Title | sed '/^\s*$/d' | wc -l) songs."
	files="$(tree -a $MUSIC | tail -n1 | awk -F\  '{print $3}') files."
    size="Which uses up $(\du -hs /mnt/ehdd2/Music | cut -c 1-4)B of storage."
    amount="Also, you have played $(w3m -dump https://libre.fm/user/phate6660/stats | grep Total | sed "s/[^0-9]//g") complete songs since the end of March 2019."
    status="$(w3m -dump https://libre.fm/user/phate6660/ | grep "playing" | sed 's/×\ //g')"
    echo -e "\nYou have:\n---------\n$artists\n$albums\n$songs\n$files\n\n$size\n$amount\n\n$status\n"
}

# Play a song via youtube search. Example: play world coming down type o negative
play() {
    search=$@
    search=${search// /+}
    mpv ytdl://ytsearch:"$search" --ytdl-format=bestaudio
}

# Play a playlist in mpv, but reverse it beforehand
reverse() {
    mpv "$1" --ytdl-raw-options=playlist-reverse=
}

# Neatly output contents of $PATH.
lspath() { echo -e "$(echo "$PATH" | sed 's/\:/\\n/g')"; }

# Function to list all files in $PWD.
list(){ for file in *; do printf '%s\n' "$file"; done; }

# With arguments, play video with mpv. Without arguments, open invido.us in firefox.
yt() { if [ -z ${1+x} ]; then firefox --new-tab invidio.us; else mpv "$1"; fi; }

# Use python as a calculator. Example: calc 2*3+4/5-6
calc() { perl -e "print($@)"; }

pvre() {
    sudo protonvpn d
    sudo protonvpn c -f
    sudo protonvpn s
    read -p 'Press [ENTER] to continue.'
}

pvp2p() {
    sudo protonvpn d
    sudo protonvpn c --p2p
    sudo protonvpn s
}

# Compare 2 directories for differences. There will be no output if both directories are identical. Includes subdirectories too.
# Example: atts $HOME/example $HOME/example2
atts() { diff -r -q "$@"; }

# Set (U)XTerm title
title() { echo -ne "\033]2;$@\007"; }

# :)
e-shrooms() {
	P=( " " █ ░ ▒ ▓ ); while :; do printf "\e[$[RANDOM%LINES+1];$[RANDOM%COLUMNS+1]f${P[$RANDOM%5]}"; done | lolcat -r
}

# This script was automatically generated by the broot program
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
br() {
    f=$(mktemp)
    (
        set +e
        broot --outcmd "$f" "$@"
        code=$?
        if [ "$code" != 0 ]; then
            rm -f "$f"
            exit "$code"
        fi
    )
    code=$?
    if [ "$code" != 0 ]; then
        return "$code"
    fi
    d=$(<"$f")
    rm -f "$f"
    eval "$d"
}

## Aliases
alias rsfetch="$HOME/.cargo/bin/rsfetch -PdbcehklrstuU@w -C0 -L/home/valley/downloads/ascii/girl5 -mmpd -pportage" # Shameless self-advertizing: https://github.com/rsfetch/rsfetch
alias onefetch="onefetch -i '/home/valley/downloads/Yes Yes(nat the lich.jpg'"
alias fetch="tewisay -f /usr/share/cowsay/cows/te.cow \"\$($HOME/.cargo/bin/rsfetch -PdbcehkMrstuU@w -C 0 -m mpd -p portage)\""
alias myip="curl --silent https://ipecho.net/plain; echo" # Display public IP Address.
alias ss="ss -ntlp"
alias aria="aria2c -c -j16 -x16 -s16 -k 1M" # aria > wget/curl | fite me
alias e="emacsclient"
alias glog="git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\" --stat"
alias tokei="tokei --files --sort code -c 100"
alias remacs="RUST_BACKTRACE=1 remacs -q"
alias gb="gameboy -a"
alias netris="ssh netris.rocketnine.space"
alias navi="navi -p /home/valley/.config/navi"
alias cstats="CCACHE_DIR=/var/cache/ccache ccache -s"
alias lsanime="tree -C -L 3 -d $ANIME $ANIME2 | sed -e /Extra/d -e /Extras/d -e /Sample/d -e /Samples/d -e /CDs/d -e /SPs/d -e /Bluray\ Menus/d -e /Holy\ Wars+Movie/d -e /Screencaps/d -e /directories/d -e '/^[[:space:]]*$/d'"
alias doom="gzdoom +sv_cheats 1 +vid_fps true +cl_capfps false +vid_maxfps 60"
alias mpl="mpv --playlist=playlist"
alias setr="xset r rate 200 60"
alias mpdr="killall -9 mpd && killall mpdscribble && mpd && mpdscribble"

alias adev="fuser -fv /dev/snd/* /dev/dsp*"
alias astat="cat /proc/asound/card0/pcm0p/sub0/hw_params"
alias avol="awk -F\"[][]\" '/dB/ { print \$2 }' <(amixer sget Master)"

alias top="btm -af"
alias find="fd -a -j4"
#alias grep="rg -i --color=auto" # use ripgrep instead of grep, ignore case differences and automatically use color
alias ls="ls -Fa --color=auto" # append indicators to filenames, show all files, automatically use color
alias cat="bat -p" # show line numbers
alias mkdir='mkdir -pv' # make any necessary parent directories, show verbose output
alias mv="mv -iv" # interactive and verbose
alias cp="xcp -vw 4" # interactive and verbose
alias rm="rm -iv" # interactive and verbose
alias ps="ps auxf" # # show all processes, display user-oriented format, show processes that aren't attached to ttys, use full-format listing
alias pse="\ps -e --forest" # list processes as a tree
alias psg="\ps aux | grep -v grep | grep -i -e VSZ -e" # search for a running process. example: psg firefox
alias psr="\ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head" # list top 10 cpu-intensive processes
alias pst="\ps -eo pid,comm,lstart,etimes,time,args"

alias lyrics='ncmpcpp -c ~/.ncmpcpp/config-lyrics' # launch my ncmpcpp config for lyric viewing
alias scriblog='clear; tail -f ~/.mpdscribble/mpdscribble.log' # tail my music-scrobbling log

alias ytdl='youtube-dl' # I'm lazy.

alias pvpn="sudo protonvpn" # Another case of me being lazy.
alias pvstat="sudo protonvpn s" # Check ProtonVPN's status.

## Source distro-specific files for functions and aliases.
source "$HOME/.gentoo"
# source "$HOME/.alpine"
# source "$HOME/.mint"
