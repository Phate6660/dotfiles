# ██╗   ██╗ █████╗ ██╗     ██╗     ███████╗██╗   ██╗
# ██║   ██║██╔══██╗██║     ██║     ██╔════╝╚██╗ ██╔╝
# ██║   ██║███████║██║     ██║     █████╗   ╚████╔╝ 
# ╚██╗ ██╔╝██╔══██║██║     ██║     ██╔══╝    ╚██╔╝  
#  ╚████╔╝ ██║  ██║███████╗███████╗███████╗   ██║   
#   ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝   

if [[ $- != *i* ]] ; then
	return
fi

### Autostart
# Enable completition
source /etc/bash/bashrc.d/bash_completion.sh

# Send notifications for finished commands (that take a long time)
eval "$(ntfy shell-integration)"

### Environmental Variables
# General
export PS1="[\@] \u \w \$ "                                                                        # Set prompt to "USER CWD $"
export PATH="/bedrock/cross/pin/bin:/bedrock/bin/:/usr/lib/ccache/bin:/home/valley/.local/bin:$HOME/.cargo/bin:$HOME/scripts:$HOME/bin:$HOME/.gem/ruby/2.4.0/bin:/bedrock/cross/bin:${PATH:+:}$PATH"
export EDITOR=emacsclient                                                                          # Set (text) editor to emacs daemon (through emacsclient)
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"                                             # Set history settings to remove duplicates
export ALPINE=/mnt/alpine                                                                          # Set void path
export SUDO_EDITOR="emacsclient"                                                                   # Set sudo editor to emacs daemon (through emacsclient)

# ntfy
export AUTO_NTFY_DONE_IGNORE="yt mpv f fff pvre pvstat emacsclient e top"                          # Make ntfy ignore these commands/aliases

# Rust
export RUST_SRC_PATH="/home/valley/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/" # Set Rust src path to make Racer work

### Functions
# Display the current weather.
wttr() {
    local request="wttr.in/${1-IP ADDRESS?u}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

# How Much Music -- Uses mpc and du to find amount of music, then w3m to scrape libre.fm for amount of songs played.
hmm () {
    artists="$(mpc list Artist | sed '/^\s*$/d' | wc -l) artists."
    albums="$(mpc list Album | sed '/^\s*$/d' | wc -l) albums."
    songs="$(mpc list Title | sed '/^\s*$/d' | wc -l) songs."
    size="Which uses up $(\du -hs ~/Music | cut -c 1-4)B of storage."
    amount="Also, you have played $(w3m -dump https://libre.fm/user/phate6660/stats | grep Total | sed "s/[^0-9]//g") complete songs."
    status="$(w3m -dump https://libre.fm/user/phate6660/ | grep "playing" | sed 's/×\ //g')"
    echo -e "\nYou have:\n---------\n$artists\n$albums\n$songs\n\n$size\n$amount\n\n$status\n"
}

# Set the title of the xterm-based/compatible terminal.
title() { echo -e '\033]2;'$1'\007'; }

# Update all packages.
update() {
    sudo emerge -avuDN world
    sudo emerge -Dac
    sudo revdep-rebuild -i
    read -p "Your system has been updated. Press [ENTER] to continue."
}

updatefull() {
    sudo emerge --sync
    sudo layman -S
    sudo emerge -avuDN world
    sudo emerge -Dac
    sudo revdep-rebuild -i
    read -p "Your system has been updated. Press [ENTER] to continue."
}

play() {
    search=$@
    search=${search// /+}
    mpv ytdl://ytsearch:"$search" --ytdl-format bestaudio
}

# Get news based on keyword(s).
newson() {
    search=$@
    search=${search// /+}
    curl getnews.tech/"$search"
}

# Dictionary
dict() {
    search=$@
    search=${search// /+}
    curl "dict://dict.org/d:$search"
}

calc() { python -c print\("$1"\); }

timeof() { \ps -eo pid,comm,lstart,etimes,time,args | grep "$1" | sed 1d; }

hc() { herbstclient "$@"; }

# OpenRC functions
start() { su -c "rc-service $1 start"; }
stop() { su -c "rc-service $1 stop"; }
restart() { su -c "rc-service $1 restart"; }
add() { su -c "rc-update add $1 $2" ;}
del() { su -c "rc-update del $1 $2"; }
rclist() { rc-update show -v; }

# BASH
lspath() { echo -e "$(echo "$PATH" | sed 's/\:/\\n/g')"; }

### Aliases
# General
alias fetch="fetch -d -k none -p -s -u"
alias rsfetch="rsfetch --no-wm-de -hulp portage"
alias myip="curl --silent https://ipecho.net/plain; echo"
alias ss="ss -ntlp"
alias du="diskus"
alias alpine="sudo mount -v -t ext4 /dev/sda5 \$ALPINE"
alias e="emacsclient"
alias ff="sudo -u ff"

# Entertainment
alias matrix="unimatrix -n -s 96 -l knnSSssu"
alias rr="/home/valley/downloads/github/rickrollrc/roll.sh"
alias parrot="curl parrot.live && sleep 1 && tput sgr0"
alias joke="echo -e \"\$(curl --silent https://icanhazdadjoke.com)\""

# {core,bin}-utils related.
alias grep="grep --color=auto"
alias ls="ls -Fa --color=auto"
alias cat="cat -n"
alias mkdir='mkdir -pv'
alias mv="mv -iv"
alias cp="cp -iv"
alias rm="rm -iv"

# Process-related.
alias ps="ps auxf"
alias pse="\ps -e --forest"
alias psg="\ps aux | grep -v grep | grep -i -e VSZ -e"
alias psr="\ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head"
alias pst="\ps -eo pid,comm,lstart,etimes,time,args"

# Mount music directories.
alias umus="sudo mount --bind '/run/media/valley/Music and Pics/Music' ~/Music/Music"
alias umus2="sudo mount --bind '/run/media/valley/music-2/Music' ~/Music/Music-2"
alias umus3="sudo mount --bind '/run/media/valley/Anime and Music/Music' ~/Music/Music-3"
alias umus4="sudo mount --bind '/run/media/valley/BD-Rips/Music' ~/Music/Music-4"

# Player, lyrics, and scrobbler log.
alias mus='ncmpcpp -c ~/.ncmpcpp/config-rwb'
alias lyrics='ncmpcpp -c ~/.ncmpcpp/config-lyrics'
alias scriblog='clear; tail -f ~/.mpdscribble/mpdscribble.log'

# YouTube
alias ytdl='youtube-dl'
alias yt="youtube-viewer"

# ProtonVPN
alias pvre="sudo pvpn -d; sudo pvpn -f; sudo pvpn --status; read -p 'Press [ENTER] to continue.'; speedtest-cli --secure --no-upload"
alias pvstat="sudo pvpn --status"
alias speed="speedtest-cli --secure --no-upload"

# Gentoo
alias changed="sudo emerge --ask --changed-use --deep @world"
alias merge="sudo emerge -atv"
alias searchfor="emerge -s"
alias rem="sudo emerge -avc"
alias frem="sudo emerge -avC"
alias clean="sudo emerge -Dac; sudo revdep-rebuild -i"
alias portup="sudo emerge -a1 sys-apps/portage"
alias genlop="sudo genlop -it"
alias lsuse="portageq envvar USE | xargs -n 1"
alias lsfeat="portageq envvar FEATURES | xargs -n 1"

# Rust
alias cargo="/home/valley/.cargo/bin/cargo"
alias rustfmt="/home/valley/.cargo/bin/rustfmt"
alias rustc="/home/valley/.cargo/bin/rustc"
