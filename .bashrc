#
# ~/.bashrc
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Customize .bashrc status stuff.
PS1="\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;99m\]\@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\d\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;118m\]\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;69m\]\h\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;244m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;15m\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\$?\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;226m\]> \[$(tput sgr0)\]"

##################################
# Autostart at terminal startup. #
##################################

# Define alias for Neofetch.
alias neofetch="clear; neofetch; echo -e '\n'"

# Fetch OS info
neofetch; printf "Don't you just love customization?" %b; echo -e '\n'

# Source some VTE bullshit.
source /etc/profile.d/vte.sh

# Set Nano as the default editor.
export EDITOR=nano

# Add ~/bin to PATH.
export PATH=$PATH:~/bin

# Source FTC for BASH.
source /usr/share/doc/find-the-command/ftc.bash

#############
# Functions #
#############

clear_fetch () {
	 neofetch 
	 printf "Don't you just love customization?" %b
	 echo -e '\n'
	 }

pipe () {
	clear
	echo "Welcome to cpipes! Please setup how you want your cpipes to look."
	echo ""
	echo "How many pipes do you want?"
	read amount
	echo ""
	echo "What is your desired framerate?"
	read framerate
	echo ""
	echo "How much of a chance do you want your pipes to change direction every second?"
	echo "(Insert a value between 0.1 and 0.9)."
	read chance
	echo ""

	cpipes --pipes=$amount --fps=$framerate --prob=$chance
}

se () {
	clear
	compgen -c | grep -i "${1:?No search parameter given}"
}

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1        ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1        ;;
            *.tbz2)      tar xvjf $1      ;;
            *.tgz)       tar xvzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

mkpasswd () {
	clear
	text1="Password: "
	text2=$(< /dev/urandom tr -dc 'A-Za-z0-9_!@#$' | head -c32)
	echo $text1$text2
	echo
}

spliturl () {
	clear
	echo Input a URL to split.
	echo ---------------------
	echo
	read url
	echo
	echo Spit URL
	echo --------
	echo "$url" | tr "? &" "\n"
	echo
}

... () {
	local arg=${1:-1};
	local dir=""
	while [ $arg -gt 0 ]; do
		dir="../$dir"
		arg=$(($arg - 1));
	done
	cd $dir >&/dev/null
}

cdate () {
	echo ""
	cal | sed "s/^/ /;s/$/ /;s/ $(date +%e) / $(date +%e | sed 's/./#/g') /"
	echo ""
}

mvf () {
	if  mv "$@"; then
		shift $(($#-1))
		if [ -d $1 ]; then
			cd ${1}
		else
			cd `dirname ${1}`
		fi
	fi
}

who_am_i () {
	echo ""
	id=$(id -un)
	echo "You are "$id"."
	echo ""
}

tor_check () {
	echo ""
	echo "Would you like me to clear your terminal before displaying results? (yes/no)"
	read answer
	if [ "$answer" = "yes" ]; then 
		clear
	else 
		echo ""
	fi
	web=$(torsocks w3m -dump check.torproject.org)
	echo "$web"
	echo ""
}

###########
# Aliases #
###########

# Print files in directory with extra info.
alias ls='clear; exa -lFha'

# Cute animated train for when you fuck up and misspell 'ls'. Requires 'sl' package.
alias sl='sl -ac'

# Process table in human readable format.
alias ps='ps auxf'

# Search for a specific running process. E.G. 'psg PROCESS'.
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Makes any necessary parent directories and lets us know of directory creation.
alias mkdir='mkdir -pv'

# Makes wget auto-continue downloads in case of errors.
alias wget='wget -c'

# Displays your public IP Address.
alias myip='ip=$(curl --silent http://ipecho.net/plain); echo ""; echo "Your IP is ("$ip")."; echo ""'

# Sets some custom configs for pixterm. Requires 'pixterm' package.
alias pixterm='pixterm -d 2 -s 2'

# Shortens the espeak command. Requires espeak package.
# OBEY THE GODLY VOICE THAT IS ESPEAK!!!!111!1!1!!
alias say='espeak'

# Make espeak say tongue twisters.
alias twisters="espeak 'Rubber baby bumpy bumpers. She sells seashells by the sea shore. Peter Piper picked a peck of pickeled peppers.'"

# Fortune (Offensive). Requires 'fortune-mod' package.
alias fortune='clear; fortune -o | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n'

# Fortune LOLCAT Requires. 'fortune-mod' and 'lolcat' packages.
alias fortune-lol='clear; fortune | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n | lolcat -t'

# Alias for show to have extra options.
# Requires 'dfshow' package.
alias show='show -a --color=always -h --time-style=locale'

# Nuke the unresponsive process. Usage: 'kill <pid>'. Find the ID with the psg alias.
alias kill='sudo kill -9'

# Launch ncmpcpp with custom config.
alias mus-dark='ncmpcpp -c ~/.ncmpcpp/config-art-dark'

# Launch ncmpcpp with custom config.
alias mus1='ncmpcpp -c ~/.ncmpcpp/config-simple'

# Launch ncmpcpp with custom config.
alias mus2='ncmpcpp -c ~/.ncmpcpp/config-simple2'

# Launch ncmpcpp with custom config.
alias mus3='ncmpcpp -c ~/.ncmpcpp/config-simple3'

# Launch ncmpcpp with custom config.
alias mus-rwb='ncmpcpp -c ~/.ncmpcpp/config-rwb'

# Launch ncmpcpp with custom config.
alias lyrics='ncmpcpp -c ~/.ncmpcpp/config-lyrics'

# Launch my alarm.
# Requires 'tmux' package, as well as my alarm script.
alias alarm="cd ~/Scripts; tmux new-session -s Alarm './alarm.sh'"

# Cheat sheet for Linux commands.
alias cheat='cd ~/Scripts; ./cheat'

# Make 'clear' actually clear the damn terminal. -_-
alias clear='printf "\033c"'

# Color testing for terminal.
alias colortest='cd ~/Scripts; clear; ./colortest.sh'

# Color testing for terminal... overkill python edition.
alias colortest-overkill='cd ~/Scripts; clear; ./colortest-overkill'

# Launch Youtube script with single command.
alias youtube='cd ~/Scripts; ./youtube'

# Define alias for Neofetch to clear screen and say the message above.
alias clearfetch="clear_fetch"

# Make ping pretty.
alias ping='bash /home/valley/Scripts/prettyping'

# Tmux session with ncmpcpp and cover art.
alias music='tmux new-session "tmux source-file ~/.ncmpcpp/tmux_session"'

# Kill tmux easier.
alias texit='tmux kill-server'

# List tmux sessions easier.
alias tls='tmux ls'

# Unified menu for all configs.
alias confmenu='clear; bash ~/Scripts/confmenu'

# Set title for BASH terminals.
alias title='. /home/valley/bin/title'

# ???
alias 0w0='clear; cat ~/.trap'

# ???
alias 0s0='clear; cat ~/.haha'

# ???
alias 0x0='clear; cat ~/.dead'

# ???
alias 0m0='clear; cat ~/.mikasa'

# ???
alias 0i0='clear; cat ~/.mirror'

# ???
alias 0l0='clear; cat ~/.loli'

# ???
alias 0b0='clear; cat ~/.beserk'

# WTF!?!?!?!?!?!?!?
alias wtf='clear; cat ~/.testing'

# Search DDG from terminal with Tor.
alias ddgr-tor='torsocks --isolate ddgr --ducky --unsafe --noua'

# Activate Tor for the shell.
alias tors='source torsocks on'

# Disable Tor for the shell.
alias tors-off='source torsocks off'

# Speedtest with extra options.
alias speed='clear; speedtest-cli --no-upload --bytes'

# Whoami.
alias whoami='who_am_i'

# Boi.
alias boi='boi_function'

# Tor check.
alias torcheck='tor_check'

# ss with most used options.
alias ss='echo ""; ss -nlt; echo ""'

# WIP img viewer.
alias img='clear; bash /home/valley/Scripts/img'

### Arch Only ###

# Update mirrors and sort based on speed. Requires 'reflector' package.
alias mirror="sudo reflector --country 'United States' --latest 200 --age 24 --sort rate --save /etc/pacman.d/mirrorlist; rm -f /etc/pacman.d/mirrorlist.pacnew; echo Finished updating mirrors."

# Do a full system update.
alias upgrade='clear; sudo pacman -Syu'

# Make installing packages easier.
alias install='sudo pacman -S'

# Make installing packages easier (AUR Edition).
alias aur='yay -S'

# Make removing packages easier.
alias remove='sudo pacman -Rns'

# Make searching Arch Repositories for packages easier.
alias searchfor='pacman -Ss'

# Make searching AUR for packages easier.
alias searchaur='yay -Ss'

# Update AUR packages (as well as the rest of the packages in your system.) Requires 'yay' package (from Github).
alias upyay='clear; yay -Syu'

### emacs ###

## Requires 'emacs' package. ##

# Play Tetris
alias tetris='emacs -q --no-splash -f tetris'

# Play Pong
alias pong='emacs -q --no-splash -f pong'

# Zone Mode
alias zone='emacs -q --no-splash -f zone'

# Talk to a Psychotherapist.
alias therapy='emacs -q --no-splash -f doctor'

# Butterfly mode
alias butterfly='emacs -q --no-splash -f butterfly'

# Play 5x5
alias 5x5='emacs -q --no-splash -f 5x5'

# Play the game of Life
alias life='emacs -q --no-splash -f life'

# Play Blackbox
alias blackbox='emacs -q --no-splash -f blackbox'

# Play Snake
alias snake='emacs -q --no-splash -f snake'

###########################
# Environmental Variables #
###########################

### GLOBAL ###
export BROWSER='firefox-nightly'

### RTV ###

## Requires 'rtv' package from AUR. ##

# Browser for RTV (Reddit CLI client.)
export RTV_BROWSER='firefox-nightly'

# Text Editor for RTV
export RTV_EDITOR='nano'

################
# Extra Tweaks #
################

# Increase history size.
export HISTSIZE=10000
export HISTFILESIZE=120000
