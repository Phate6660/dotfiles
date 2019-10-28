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

## Check if interactive.
if [[ $- != *i* ]] ; then
	return
fi

## Autostart
# Enable completition
source /etc/bash/bashrc.d/bash_completion.sh

# bash settings
shopt -s checkwinsize

## Environmental Variables
# General
export PATH="$PATH:$HOME/.cargo/bin:$HOME/scripts:$HOME/.local/bin"
export PS1="[\@] \u \w \$ "
export LS_COLORS="$(vivid generate molokai)"
export EDITOR="/usr/bin/vim"
export SUDO_EDITOR="/usr/bin/vim"
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth" 
# Pastel
export PASTEL_COLOR_MODE=24bit

## Functions
wttr() {
    local request="wttr.in/${1-[REDACTED]?u}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

hmm () {
    artists="$(mpc list Artist | sed '/^\s*$/d' | wc -l) artists."
    albums="$(mpc list Album | sed '/^\s*$/d' | wc -l) albums."
    songs="$(mpc list Title | sed '/^\s*$/d' | wc -l) songs."
    size="Which uses up $(\du -hs ~/Music | cut -c 1-4)B of storage."
    amount="Also, you have played $(w3m -dump https://libre.fm/user/phate6660/stats | grep Total | sed "s/[^0-9]//g") complete songs."
    status="$(w3m -dump https://libre.fm/user/phate6660/ | grep "playing" | sed 's/×\ //g')"
    echo -e "\nYou have:\n---------\n$artists\n$albums\n$songs\n\n$size\n$amount\n\n$status\n"
}

update() {
    sudo emerge -avuDN world
    sudo emerge -Dac
    sudo revdep-rebuild -i
    read -p "Your system has been updated. Press [ENTER] to continue."
}

updatefull() {
    sudo emerge --sync        # Sync repositories
    sudo emerge -avuDN world  # Update packages
    sudo emerge -Dac          # Remove un-needed packages
    sudo revdep-rebuild -i    # Rebuild any required dependencies
    read -p "Your system has been updated. Press [ENTER] to continue."
}

play() {
    search=$@
    search=${search// /+}
    mpv ytdl://ytsearch:"$search" --ytdl-format bestaudio
}

lspath() { echo -e "$(echo "$PATH" | sed 's/\:/\\n/g')"; }

list(){ for file in *; do printf '%s\n' "$file"; done; }

yt() { if [ -z ${1+x} ]; then firefox --new-tab invidio.us; else mpv "$1"; fi; }

## Aliases
alias rsfetch="rsfetch --no-wm-de -hup portage -L /mnt/ehdd/Pictures/ascii/leaf"
alias myip="curl --silent https://ipecho.net/plain; echo"
alias ss="ss -ntlp"
alias aria="aria2c -c -j16 -x16 -s16 -k 1M"
alias fucking="sudo"

alias grep="rg -i --color=auto"
alias ls="ls -Fa --color=auto"
alias cat="cat -n"
alias mkdir='mkdir -pv'
alias mv="mv -iv"
alias cp="cp -iv"
alias rm="rm -iv"
alias ps="ps auxf"
alias pse="\ps -e --forest"
alias psg="\ps aux | grep -v grep | grep -i -e VSZ -e"
alias psr="\ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head"
alias pst="\ps -eo pid,comm,lstart,etimes,time,args"

alias mus='ncmpcpp -c ~/.ncmpcpp/config-rwb'
alias lyrics='ncmpcpp -c ~/.ncmpcpp/config-lyrics'
alias scriblog='clear; tail -f ~/.mpdscribble/mpdscribble.log'

alias ytdl='youtube-dl'

alias pvre="sudo pvpn -d; sudo pvpn -f; sudo pvpn --status; read -p 'Press [ENTER] to continue.'; speedtest-cli --secure --no-upload"
alias pvstat="sudo pvpn --status"
alias speed="speedtest-cli --secure --no-upload"

alias merge="sudo emerge -atv"
alias changed="sudo emerge --ask --changed-use --deep @world"
alias emake="sudo -e /etc/portage/make.conf"
alias searchfor="emerge -s"
alias rem="sudo emerge -avc"
alias frem="sudo emerge -avC"
alias clean="sudo emerge -Dac; sudo revdep-rebuild -i"
alias portup="sudo emerge -a1 sys-apps/portage"
alias genlop="sudo genlop -it"
alias lsuse="portageq envvar USE | xargs -n 1"
alias lsfeat="portageq envvar FEATURES | xargs -n 1"
alias lspkg="printf '%s\n' /var/db/pkg/*/*/"
alias pkgsum="sudo qlop -c | grep total"
