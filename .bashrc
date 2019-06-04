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
source /home/valley/bin/mcfly.bash

### Environmental Variables
export PS1="[\W]-> "
export PATH=$PATH:/home/valley/.cargo/bin:/home/valley/scripts:$HOME/bin
export EDITOR="nano"
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"

### Functions

wttr() {
    # change [REDACTED] to your default location. 
    # It can be anything from an IP Address, to coordinates, to just the name of a city.
    local request="wttr.in/${1-[REDACTED]?u}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

hmm () {
    artists="$(echo "$(mpc list Artist | sed '/^\s*$/d' | wc -l) artists.")"
    albums="$(echo "$(mpc list Album | sed '/^\s*$/d' | wc -l) albums.")"
    songs="$(echo "$(mpc list Title | sed '/^\s*$/d' | wc -l) songs.")"
    size="$(echo Which uses up "$(du -hs ~/Music | cut -c 1-4)"B of storage.)"
    amount="$(echo "Also, you have played $(w3m -dump https://libre.fm/user/phate6660/stats | grep Total | sed "s/[^0-9]//g") complete songs.")"
    echo -e "You have:\n---------\n$artists\n$albums\n$songs\n\n$size\n$amount\n"
}

update () {
    # This if statement was added as it is gentoo-netiquette to sync with repos ONCE per day. 
    # Any more will result in a temp IP ban. (I have a bad habit of updating multiple times a day.)
    # (I blame Arch for that.)
    if [ "$1" = "full" ]; then
	sudo emerge --sync
    else
	echo "Will not sync with repos."
    fi
    sudo emerge -avuDN world
    sudo emerge -Da --exclude=rust --exclude=cargo --depclean
    sudo revdep-rebuild -i
}

f() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

### Aliases

# General
alias ls="exa -lFha"
alias cat="bat"
alias fetch="rsfetch --no-wm-de -huMp portage"
alias mkdir='mkdir -pv'
alias myip="curl --silent https://ipecho.net/plain; echo"
alias ss="ss -ntlp"

# Process-related.
alias ps="ps auxf"
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

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

# Gentoo
alias portup="sudo emerge --ask --oneshot sys-apps/portage"
alias install="sudo emerge -atv"
alias searchfor="emerge --searchdesc"
alias remove="sudo emerge --ask --verbose --depclean"
alias remove-force="sudo emerge --ask --verbose --unmerge"
alias changed="sudo emerge --ask --changed-use --deep @world"
alias pkglist="qlist -I > ~/.pkglist"
