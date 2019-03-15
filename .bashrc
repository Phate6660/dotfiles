#
# ~/.bashrc
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Customize .bashrc status stuff.
PS1="\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;99m\]\@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\d\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;118m\]\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;69m\]\h\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\n\[$(tput bold)\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;244m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;15m\][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;51m\]\$?\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;255m\]-\[$(tput sgr0)\]\[\033[38;5;226m\]> \[$(tput sgr0)\]"

#############
# Variables #
#############

# Add extra directories to PATH.
export PATH=$PATH:~/bin:~/Scripts:/home/valley/.cargo/bin

# Set tar to use max compression
export GZIP=-9
export XZ_OPT=-9

# Allow filet top open files.
export FILET_OPENER="xdg-open"

# Set Nano as the default editor.
export EDITOR=nano

quotes () {
	printf "\"Arguing that you don't care about the right to privacy because you have nothing to hide is no different than saying you don't care about free speech because you have nothing to say.\"\n\n- Edward Snowden (on Reddit)\n" | tewisay -f blank
	printf "\"We all need places where we can go to explore without the judgmental eyes of other people being cast upon us,\nonly in a realm where we're not being watched can we really test the limits of who we want to be.\nIt's really in the private realm where dissent, creativity and personal exploration lie.\"\n\n- Glenn Greenwald (in Huffington Post)\n" | tewisay -f blank
	printf "\"The NSA has built an infrastructure that allows it to intercept almost everything.\nWith this capability, the vast majority of human communications are automatically ingested without targeting.\nIf I wanted to see your emails or your wife's phone, all I have to do is use intercepts.\nI can get your emails, passwords, phone records, credit cards.\nI don't want to live in a society that does these sort of things...\nI do not want to live in a world where everything I do and say is recorded.\nThat is not something I am willing to support or live under.\"\n\n- Edward Snowden (in The Guardian)\n" | tewisay -f blank
	printf "\"He who is unable to live in society, or who has no need because he is sufficient for himself, must be either a beast or a god.\"\n\n- Aristotle" | tewisay -f blank
	printf "\"I don't base my life upon fear about what might happen tomorrow. I live for the day. I seize the day.\"\n\n- Peter Steele" | tewisay -f blank
}

# Define alias for Neofetch.
alias neofetch="clear; tewisay -f blank '$(neofetch --color_blocks off --backend off | sed '/^\s*$/d')'"

##################################
# Autostart at terminal startup. #
##################################

# Fetch OS info
paste -d " " <(echo "$(neofetch)") <(echo "$(quotes)")

vpnstat () {
	if systemctl is-active --quiet pvpn-fast-restart.timer
		then time="$(systemctl status pvpn-fast-restart.timer | grep Trigger | cut -c 41-45)"
		else time="N/A"
	fi

	if systemctl is-active --quiet pvpn-fast
		then status="ProtonVPN is running ($(curl --silent http://ipecho.net/plain)), and will restart in ""$time""."
		else status="ProtonVPN is off ($(curl --silent http://ipecho.net/plain)), you should really turn it on -_-."
	fi
	
	echo "$status"
}

# Display VPN status.
vpnstat

# Source some VTE bullshit.
source /etc/profile.d/vte.sh

# Source goto
source ~/bin/goto.sh

# Source FTC for BASH.
source /usr/share/doc/find-the-command/ftc.bash

# For turning thefuck into fuck.
eval "$(thefuck --alias)"

# For mcfly
if [[ -f /home/valley/downloads/mcfly-v0.3.1-x86_64-unknown-linux-gnu.tar-1/mcfly.bash ]]; then
  source /home/valley/downloads/mcfly-v0.3.1-x86_64-unknown-linux-gnu.tar-1/mcfly.bash
fi

#############
# Functions #
#############

clearfetch () {
	paste -d " " <(echo "$(neofetch)") <(echo "$(quotes)")
}

pipe () {
	clear
	echo "Welcome to cpipes! Please setup how you want your cpipes to look."
	echo ""
	echo "How many pipes do you want?"
	read -r amount
	echo ""
	echo "What is your desired framerate?"
	read -r framerate
	echo ""
	echo "How much of a chance do you want your pipes to change direction every second?"
	echo "(Insert a value between 0.1 and 0.9)."
	read -r chance
	echo ""

	cpipes --pipes="$amount" --fps="$framerate" --prob="$chance"
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

# This function requires 'pwgen' and 'bitwarden-cli'.
mkpasswd () {
	clear
	pass1="$(pwgen -s 32)"
	pass2="$(< /dev/urandom tr -dc 'A-Za-z0-9!@#$%^*' | head -c32)"
	pass3="$(bw generate -ulns --length 32)"
	echo -e "Choose which randomly generated password you would prefer to use.\n"; echo -e "Your password is: ""$pass1"" \nYour password is: ""$pass2"" \nYour password is: ""$pass3"""
	echo ""
	echo "Would you like these combined into one long password? (yes/no)"
	read -r answer
	if [ "$answer" = "yes" ]; then 
		echo ""
		echo """$pass1""""$pass2""""$pass3"""
		echo ""
	else 
		echo ""
	fi
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
	while [ "$arg" -gt 0 ]; do
		dir="../$dir"
		arg=$(($arg - 1));
	done
	cd $dir >&/dev/null || exit
}

cdate () {
	echo ""
	cal | sed "s/^/ /;s/$/ /;s/ $(date +%e) / $(date +%e | sed 's/./#/g') /"
	echo ""
}

mvf () {
	if  mv "$@"; then
		shift $(($#-1))
		if [ -d "$1" ]; then
			cd "${1}" || exit
		else
			cd $(dirname "${1}") || exit
		fi
	fi
}

who_am_i () {
	echo ""
	id=$(id -un)
	echo "You are ""$id""."
	echo ""
}

tor_check () {
	echo ""
	echo "This doesn't test if any of your programs are actually connected, it just tests to see if your Tor client is fuctional."
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

randnum () {
	echo "What is the starting number?"
	read num1
	echo -e "\nWhat is the ending number?"
	read num2
	echo -e "\nYour random number is $(shuf -i"$num1"-"$num2" -n1)."
}

# WIP img viewer.
# Stuck this alias in Functions section due to one of the functions requiring it.
alias img='clear; bash /home/valley/Scripts/img'

neoscreen () {
	if test -e '/tmp/cover.png'; then icon='/tmp/cover.png'; else icon='/home/valley/downloads/yenpinup_by_raikoart-dcqhflq-35.png'; fi
	cd '/home/valley/Pictures/unixporn/' || exit
	clearfetch
	echo "The notification checks for album art of the currently playing music and uses it as an icon."
	echo -e "If no album art is found ('/tmp/cover.png') it will use a preset backup picture. \n"
	notify-send.sh --urgency='critical' --expire-time='20000' 'Hey-' 'Say Cheese-' --icon="$icon"
	scrot -c -d 5
}

display_center () {
    columns="$(tput cols)"
    while IFS= read -r line; do
        printf "%*s\\n" $(( (${#line} + columns) / 2)) "$line"
    done < "$1"
}

# Display age of Linux install. (Assuming install is on sda3.)
myage () {
	echo
	echo "$(sudo tune2fs -l /dev/sda3 | grep Filesystem\ created: | cut -c 27-50)	|$(calc "$(sudo tune2fs -l /dev/sda3 | grep Filesystem\ created: | cut -c 47-50 | sed 's/ //g')" - "$(date +%Y)") years old."
	echo
}

# Displays your public IP Address.
myip () {
	echo "Would you like me to clear your terminal before displaying results? (yes/no)"
	read -r answer
	if [ "$answer" = "yes" ]; then 
		clear
		echo -e "Your IP is ($(curl --silent http://ipecho.net/plain)).\n"
	else 
		echo ""
		echo -e "Your IP is ($(curl --silent http://ipecho.net/plain)).\n"
	fi
}

type_function () {
	echo "Would you like me to clear your terminal before displaying results? (yes/no)"
	read answer
	if [ "$answer" = "yes" ]; then 
		clear
		echo "Input the command you would like to check."
		read -r cmd
		echo ""
		type "$cmd"
		echo ""
	else 
		echo ""
		echo "Input the command you would like to check."
		read -r cmd
		echo ""
		type "$cmd"
		echo ""
	fi
}

speedtest () {
	clear
	{
	echo -e "VPN OFF | Date: $(date)\n-------"
	speedtest-cli --secure --no-upload
	echo ""
	} >> ~/speedtest.log
	sed -r -i.bak 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/\[IP REDACTED\]/g' ~/speedtest.log
	cat ~/speedtest.log
}

speedtestvpn () {
	clear
	{
	echo -e "VPN ON | Date: $(date)\n------"
	speedtest-cli --secure --no-upload
	echo ""
	} >> ~/speedtest.log
	sed -r -i.bak 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/\[IP REDACTED\]/g' ~/speedtest.log
	cat ~/speedtest.log
}

# Print files in directory with extra info. Requires 'exa' package.
alias ls='clear; exa -lFha'

lunduke () {
	cd ~/RSS/The\ Lunduke\ Show
	echo "Downloading latest mp3 from The Lunduke Show's RSS feed."
	curl -s 'http://vault.lunduke.com/LundukeShowMP3.xml' | awk '/enclosure/{system("wget -nc "$2);exit}' FS=\"
	podcast=$(\ls -Art | tail -n 1)
	mpv --no-video "$podcast"
}

myinfo () {
	curl ifconfig.co
	curl ifconfig.co/country
	curl ifconfig.co/city
}

display_center(){
    columns="$(tput cols)"
    while IFS= read -r line; do
        printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
    done < "$1"
}

display_right(){
    columns="$(tput cols)"
    while IFS= read -r line; do
        printf "%*s\n" $columns "$line"
    done < "$1"
}

muset () {
	PROMPT_COMMAND='echo -ne "\033]0;Music\007"'
	tmux new-session -s "Music" "bash"
}

###########
# Aliases #
###########

# ...
alias smol="filet"

# ...
alias fucking="sudo"

# Make 'clear' actually clear the damn terminal. -_-
alias clear='printf "\033c"'

# So I don't have to use 'clear' every time.
alias cat='clear; cat'

# BASH cheat sheet.
alias bcheat="curl 'https://catonmat.net/ftp/readline-emacs-editing-mode-cheat-sheet.txt'"

# Cute animated train for when you fuck up and misspell 'ls'. Requires 'sl' package.
alias sl='sl -ac | lolcat'

# Process table in human readable format.
alias ps='ps auxf'

# Search for a specific running process. E.G. 'psg PROCESS'.
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Makes any necessary parent directories and lets us know of directory creation.
alias mkdir='mkdir -pv'

# Makes wget auto-continue downloads in case of errors.
alias wget='wget -c'

# Sets some custom configs for pixterm. Requires 'pixterm' package.
alias pixterm='pixterm -d 2 -s 2'

# Shortens the espeak command. Requires espeak package.
# OBEY THE GODLY VOICE THAT IS ESPEAK!!!!111!1!1!!
alias say='espeak'

# Make espeak say tongue twisters.
alias twisters="espeak 'Rubber baby bumpy bumpers. She sells seashells by the sea shore. Peter Piper picked a peck of pickeled peppers.'"

# Fortune (Offensive). Requires 'fortune-mod' package.
alias fortune='clear; fortune -o | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n'

# Fortune LOLCAT. Requires 'fortune-mod' and 'lolcat' packages.
alias fortune-lol='clear; fortune | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n | lolcat -a'

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

# Launch my alarm (school).
alias alarm="tmux new-session -s \"School Alarm\" \"termdown -a -b -c 10 -f epic -q 10 -t 'Time for your next class.' -T 'School' -v en-us+f4 50m\""

# Launch my alarm (general).
alias alarm2="termdown -a -b -c 10 -f epic -q 10 -v en-us+f4 $2"

# Kill tmux easier.
alias texit='tmux kill-server'

# List tmux sessions easier.
alias tls='tmux ls'

# Search DDG from terminal with Tor.
alias ddgr-tor='torsocks --isolate ddgr --ducky --unsafe --noua'

# Activate Tor for the shell.
alias tors='source torsocks on'

# Disable Tor for the shell.
alias tors-off='source torsocks off'

# Speedtest with extra options.
alias speed='speedtest'
alias vpnspeed='speedtestvpn'

# Whoami.
alias whoami='who_am_i'

# Tor check.
alias torcheck='tor_check'

# ss with most used options.
alias ss='echo ""; sudo netstat -plnt; echo ""'

# Make using github easier.
alias ready='git add .'
alias commit='git commit -m "Add existing file."'
alias push='git push origin master'
alias pull='git pull https://github.com/Phate6660/dotfiles'

# ...
alias flife='clear; while :; do printf "%-10s\n" "fuck my life" | lolcat -a && printf "%115s\n" "fuck my life" | lolcat -a && printf "%226s\n" "fuck my life" | lolcat -a; done'

# ...
alias a-p='clear; absolutely-proprietary -f'

# Display shitpost-esque script I made.
alias email='clear; display_center ~/.email | lolcat -a'

# Mount music directory.
alias umus="sudo mount --bind '/run/media/valley/Music and Pics/Music' ~/Music/Music"
alias umus2="sudo mount --bind '/run/media/valley/music-2/Music' ~/Music/Music-2"
alias umus3="sudo mount --bind '/run/media/valley/Anime and Music/Music' ~/Music/Music-3"

# Required 'pwgen' package.
alias mksec='mkpasswd'

alias mkph='xkcdpass -i -C capitalize'

# ...
alias type='type_function'

# ...
alias define='fileinfo'

# Restart TOR. Requires 'tor' package.
alias retor='systemctl restart tor'

# Alias for youtube-dl.
alias ytdl='youtube-dl'

# ...
alias dbstat='while :; do clear && echo -e "Music Stats\n-----------\n" && mpc stats; sleep 60; done'

# ...
alias covimg='while :; do clear && img /tmp/cover.png; sleep 1; done'
alias pacloop='while :; do clear && cat ~/pac; sleep 1; done'
alias clyrics='while :; do clear && ~/Scripts/cat-lyrics; sleep 5; done'

# Log for mpdscribble
alias scriblog='clear; tail -f ~/.mpdscribble/mpdscribble.log'

# Log for mpd
alias mpdlog='clear; tail -f ~/.mpd/mpd.log'

# List artists
alias lsmus='clear; cat ~/artists | tewisay'

# Save list of artists.
alias saveart="mpc list Artist | sed '/^\s*$/d' > ~/artists"

# Display cheat sheet for fff.
alias fcheat="echo -e '\n$(\cat ~/.fff-cheat)\n'"

# Extra options for gotop.
alias gotop='gotop -c monokai -pas'

# View clipboard contents. Requires 'xclip'.
alias vclip="xclip -o"

### For /etc/hosts related stuff ###

# Alias to show amount of domains being blocked with /etc/hosts.
alias lshosts="echo ""$(\cat /etc/hosts | grep -v '^#' | wc -l) domains are being blocked with /etc/hosts."""

# Alias to edit /etc/hosts as root with Geany.
alias ehosts='sudo geany /etc/hosts'

# Alias to edit /usr/local/bin/autohosts as root with Geany.
alias eahosts='sudo geany /usr/local/bin/autohosts'

### For Apache server ###

# Edit config
alias aconf='sudo nano /etc/httpd/conf/httpd.conf'

# View access log
alias aalog='cat /var/log/httpd/access_log'

# View ssl log
alias assl='cat /var/log/httpd/ssl_request_log'

# View error log
alias aerr='cat /var/log/httpd/error_log'

### For dictd server ###

# Query dictd server info.
alias infod='dict -I'

# Query english dictionary.
alias engd='dict -d gcide'

# Query computer dictionary.
alias pcd='dict -d foldoc'

# Query wikt dictionary
alias wiktd='dict -d wikt-en-all'

# Query devil dictionary.
alias devild='dict -d devils'

### For systemd services ###

# Start service.
alias start='sudo systemctl start'

# Stop service.
alias stop='sudo systemctl stop'

# Restart service.
alias restart='sudo systemctl restart'

# Enable service.
alias enable='sudo systemctl enable'

# Disable service.
alias disable='sudo systemctl disable'

# Reload daemon.
alias reload='sudo systemctl daemon-reload'

# Show status of service.
alias status='systemctl status'

# List all services.
alias sysls='systemctl list-units --all'

# List all timers.
alias timers='systemctl list-timers --all'

### Requires protonvpn-cli. ###

# Show status of VPN.
alias pvstat='clear; sudo sudo pvpn --status'

# .
alias pvcheck="secho; pvstat; read -p 'Press [ENTER] to continue.'; vpnspeed"

# VPN status.
alias vpnstatus="vpnstat"

# VPN logs.
alias vpnlog='sudo cat /root/.protonvpn-cli/connection_logs'

# Restart pvpn-fast-restart.timer correctly.
alias vpntimre='sudo systemctl stop pvpn-fast-restart.timer; sudo systemctl start pvpn-fast-restart.timer'

### Arch Only ###

# Update mirrors and sort based on speed. Requires 'reflector' package.
mirror () {
	sudo reflector -p https --latest 30 --number 20 --sort rate --save /etc/pacman.d/mirrorlist
	sudo rm -f /etc/pacman.d/mirrorlist.pacnew
	read -p "Finished updating mirrors."
	cat /etc/pacman.d/mirrorlist | less
}

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

# Refresh database.
alias refresh="sudo pacman -Syyu"

###########################
# Environmental Variables #
###########################

### GLOBAL ###
export BROWSER='firefox-nightly'

### RTV ###

## Requires 'rtv' package from AUR. ##

# Browser for RTV (Reddit CLI client.)
export RTV_BROWSER='w3m'

# Text Editor for RTV
export RTV_EDITOR='nano'

################
# Extra Tweaks #
################

# Increase history size.
export HISTSIZE=10000
export HISTFILESIZE=120000

