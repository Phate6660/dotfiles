Note: Everything `mpv` related has been moved to [mpv-config](https://github.com/Phate6660/mpv-config).<br>
I got very tired of Github telling me that over half my dotfiles were written in Lua.

`$ tree -a -I .git`

```
.
├── .alpine -- alpine-specific stuff to be sourced in .bashrc
├── ascii -- ascii art
│   ├── ahegao
│   ├── anime
│   ├── girl
│   ├── girl2
│   ├── girl3
│   ├── girl4
│   ├── girl5
│   ├── goku
│   ├── neko
│   ├── neko2
│   ├── neko3
│   ├── tifa
│   ├── totoro
│   └── vash
├── .bashrc -- bash config
├── .cache
│   └── wal -- themes for various stuff
│       ├── colors
│       ├── colors.css
│       ├── colors.hs
│       ├── colors.json
│       ├── colors-kitty.conf
│       ├── colors-konsole.colorscheme
│       ├── colors-oomox
│       ├── colors-putty.reg
│       ├── colors-rofi-dark.rasi
│       ├── colors-rofi-light.rasi
│       ├── colors.scss
│       ├── colors.sh
│       ├── colors-speedcrunch.json
│       ├── colors-sway
│       ├── colors-tty.sh
│       ├── colors-wal-dmenu.h
│       ├── colors-wal-dwm.h
│       ├── colors-wal-st.h
│       ├── colors-wal-tabbed.h
│       ├── colors-wal.vim
│       ├── colors-waybar.css
│       ├── colors.Xresources
│       ├── colors.yml
│       ├── schemes
│       │   └── _mnt_ehdd_Pictures_wallpapers_8md6RX_png_dark_None_None_1.1.0.json
│       ├── sequences
│       └── wal
├── .config
│   ├── bspwm
│   │   └── bspwmrc
│   ├── cava
│   │   └── config
│   ├── discord-rpc -- mpd-discord-rpc config
│   │   └── config.toml
│   ├── dunst
│   │   └── dunstrc
│   ├── greenclip.cfg
│   ├── gtk-3.0
│   │   └── gtk.css
│   ├── herbstluftwm
│   │   └── autostart
│   ├── neofetch
│   │   └── config.conf
│   ├── openbox
│   │   ├── autostart
│   │   ├── environment
│   │   └── rc.xml
│   ├── qutebrowser
│   │   └── config.py
│   ├── rofi
│   │   └── config
│   ├── rtv
│   │   └── rtv.cfg
│   ├── sxhkd
│   │   └── sxhkdrc
│   ├── tint2 -- tint2 configs
│   │   ├── tint2rc-bottom
│   │   ├── tint2rc-side
│   │   └── tint2rc-top
│   ├── vis
│   │   ├── colors
│   │   │   ├── index
│   │   │   ├── rainbow
│   │   │   └── rgb
│   │   └── config
│   ├── youtube-dl
│   │   └── config
│   └── youtube-viewer
│       └── youtube-viewer.conf
├── dwm
│   ├── config.def.h -- config for dwm
│   └── patches -- patches for dwm
│       ├── dwm-gaplessgrid-20160731-56a31dc.diff
│       ├── dwm-gridmode-5.8.2.diff
│       ├── dwm-noborder-6.2.diff
│       ├── dwm-r1615-mpdcontrol.diff
│       ├── dwm-r1615-selfrestart.diff
│       ├── dwm-restartsig-20180523-6.2.diff
│       └── dwm-warp-git-20160626-7af4d43.diff
├── .emacs.d
│   ├── exwm.el -- stuff for exwm
│   ├── functions.el -- contains functions
│   ├── init.el -- main init file
│   ├── packages.el -- stuff related to packages
│   └── settings.el -- settings
├── escape_sequence_art -- art made with escape sequences and unicode blocks
│   ├── beserk
│   ├── dead
│   ├── haha
│   ├── loli
│   ├── mikasa
│   ├── mirror
│   └── trap
├── etc
│   ├── dnscrypt-proxy
│   │   └── dnscrypt-proxy.toml
│   ├── fstab
│   └── portage
│       ├── make.conf
│       ├── make.conf (old)
│       ├── package.accept_keywords
│       ├── package.license
│       ├── package.mask
│       └── package.use
│           └── 00cpuflags
├── .gentoo -- gentoo-specific stuff to be sourced in .bashrc
├── .inputrc -- change keybindings and stuff in bash
├── kernel -- kernel configs
│   ├── 4.19.72-gentoo-VALLEY-config
│   ├── 5.4.31-ck-valley-config
│   └── 5.4.48-ck-valley-config
├── .mint -- mint-specific stuff to be sourced in .bashrc
├── .mozilla
│   └── PROFILE
│       └── chrome
│           ├── userChrome.css
│           └── userContent.css
├── .mpd
│   ├── mpd.conf
│   └── mpd.conf (pi)
├── .mpdscribble
│   └── mpdscribble.conf
├── .nanorc
├── .ncmpcpp
│   ├── config
│   └── config-lyrics
├── README.md -- what you're reading right now ;)
├── scripts -- various scripts
│   ├── art.sh
│   ├── general
│   ├── ips.sh
│   ├── launcher
│   ├── temp
│   ├── wall
│   └── xfort
├── .tmux.conf
├── .vimrc
├── Windows
│   └── keybindings.ahk
├── .xinitrc
├── .xmonad
│   └── xmonad.hs
└── .Xresources

40 directories, 123 files
```
