# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

### Autostart
# Enable mcfly, a history viewer/editor/executor written in Rust.
source /home/valley/bin/mcfly.bash

# Enable completition
source /etc/bash/bashrc.d/bash_completion.sh

# Alias thefuck to fuck
eval $(thefuck --alias)

### Environmental Variables
# General
export PS1='[$(tput setaf 2)\u$(tput sgr0):$(tput setaf 3)\w$(tput sgr0)]-> '
export PATH="$HOME/.cargo/bin:$HOME/scripts:$HOME/bin:$PATH"
export EDITOR=nano
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
export LFS=/mnt/lfs

# fff
export FFF_FAV1=/run/media/valley
export FFF_FAV2=/home/ff
export FFF_FAV3=~/downloads
export FFF_FAV4=~/downloads/github
export FFF_FAV5=~/projects
export FFF_FAV6=
export FFF_FAV7=
export FFF_FAV8=
export FFF_FAV9=

### Functions
wttr() {
    # Replace [REDACTED] with your location (ip, city, etc.)
    local request="wttr.in/${1-[REDACTED]?u}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

hmm () {
    artists="$(echo "$(mpc list Artist | sed '/^\s*$/d' | wc -l) artists.")"
    albums="$(echo "$(mpc list Album | sed '/^\s*$/d' | wc -l) albums.")"
    songs="$(echo "$(mpc list Title | sed '/^\s*$/d' | wc -l) songs.")"
    size="$(echo Which uses up "$(\du -hs ~/Music | cut -c 1-4)"B of storage.)"
    amount="$(echo "Also, you have played $(w3m -dump https://libre.fm/user/phate6660/stats | grep Total | sed "s/[^0-9]//g") complete songs.")"
    echo -e "\nYou have:\n---------\n$artists\n$albums\n$songs\n\n$size\n$amount\n"
}

f() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

title() { echo -e '\033]2;'$1'\007'; }

### Aliases
# General
alias rsfetch="rsfetch --no-wm-de -huMp portage"
alias myip="curl --silent https://ipecho.net/plain; echo"
alias ss="ss -ntlp"
alias du="diskus"
alias emacs="emacs -nw"
alias lfs="sudo mount -v -t ext4 /dev/sda5 \$LFS"

# core/bin utils-related.
alias grep="grep --color=auto"
alias ls="ls -a --color=auto"
alias cat="bat"
alias mkdir='mkdir -pv'
alias mv="mv -iv"
alias cp="cp -iv"
alias rm="rm -iv"

# Process-related.
alias ps="ps auxf"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias htop="htop -t"
alias vtop="htop -u valley"

# Mount music directories.
alias umus="sudo mount --bind '/run/media/valley/Music and Pics/Music' ~/Music/Music"
alias umus2="sudo mount --bind '/run/media/valley/music-2/Music' ~/Music/Music-2"
alias umus3="sudo mount --bind '/run/media/valley/Anime and Music/Music' ~/Music/Music-3"
alias umus4="sudo mount --bind '/run/media/valley/BD-Rips/Music' ~/Music/Music-4"

# Player, lyrics, and scrobbler log.
alias mus-rwb='ncmpcpp -c ~/.ncmpcpp/config-rwb'
alias lyrics='ncmpcpp -c ~/.ncmpcpp/config-lyrics'
alias scriblog='clear; tail -f ~/.mpdscribble/mpdscribble.log'

# YouTube
alias ytdl='youtube-dl'
alias yt="youtube-viewer"

# ProtonVPN
alias pvre="sudo pvpn -d; sudo pvpn -f; sudo pvpn --status; read -p 'Press [ENTER] to continue.'; speedtest --secure --no-upload"
alias pvstat="sudo pvpn --status"
alias speed="speedtest --secure --no-upload"

# Gentoo
alias merge="sudo emerge -atv"
alias searchfor="emerge --search"
alias rem="sudo emerge -av --depclean"
alias frem="sudo emerge -av --unmerge"
alias clean="sudo emerge -Da --depclean; sudo revdep-rebuild -i"
