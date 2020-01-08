`$ tree -a -I .git`
```
.
├── .bashrc
├── .cache
│   └── wal -- these are for colorschemes for various things
│       ├── colors
│       ├── colors.css
│       ├── colors.hs
│       ├── colors.json
│       ├── colors-kitty.conf
│       ├── colors-konsole.colorscheme
│       ├── colors-oomox
│       ├── colors-putty.reg
│       ├── colors-rofi-dark.rasi
│       ├── colors-rofi-light.rasi
│       ├── colors.scss
│       ├── colors.sh
│       ├── colors-speedcrunch.json
│       ├── colors-sway
│       ├── colors-tty.sh
│       ├── colors-wal-dmenu.h
│       ├── colors-wal-dwm.h
│       ├── colors-wal-st.h
│       ├── colors-wal-tabbed.h
│       ├── colors-wal.vim
│       ├── colors-waybar.css
│       ├── colors.Xresources
│       ├── colors.yml
│       ├── schemes
│       │   └── _mnt_ehdd_Pictures_wallpapers_8md6RX_png_dark_None_None_1.1.0.json
│       ├── sequences
│       └── wal
├── .config
│   ├── bspwm
│   │   └── bspwmrc -- bspwm configuration, basically a shell script and it needs to be executable
│   ├── cava
│   │   └── config
│   ├── dunst
│   │   └── dunstrc
│   ├── greenclip.cfg
│   ├── gtk-3.0
│   │   └── gtk.css -- custom css for gtk3 programs
│   ├── herbstluftwm
│   │   └── autostart -- herbstluftwm configuration, if I recall correctly it's also pretty much a shell script
│   ├── mpv
│   │   ├── input.conf -- mpv configuration: controls
│   │   └── mpv.conf -- mpv configuration: main/general options
│   ├── neofetch
│   │   └── config.conf
│   ├── openbox
│   │   ├── autostart
│   │   ├── environment
│   │   └── rc.xml -- openbox configuration
│   ├── qutebrowser
│   │   └── config.py
│   ├── rofi
│   │   └── config
│   ├── rtv
│   │   └── rtv.cfg
│   ├── sxhkd
│   │   └── sxhkdrc -- hotkey (keybinding) daemon, required for bspwm, but also a nice program to have in general
│   ├── vis
│   │   ├── colors -- vis colorschemes
│   │   │   ├── index
│   │   │   ├── rainbow
│   │   │   └── rgb
│   │   └── config -- vis config
│   ├── youtube-dl
│   │   └── config
│   └── youtube-viewer
│       └── youtube-viewer.conf
├── dwm
│   ├── config.def.h -- dwm config
│   └── patches -- patches to expand dwm
│       ├── dwm-gaplessgrid-20160731-56a31dc.diff
│       ├── dwm-gridmode-5.8.2.diff
│       ├── dwm-noborder-6.2.diff
│       ├── dwm-r1615-mpdcontrol.diff
│       ├── dwm-r1615-selfrestart.diff
│       ├── dwm-restartsig-20180523-6.2.diff
│       └── dwm-warp-git-20160626-7af4d43.diff
├── .emacs -- emacs config
├── etc
│   ├── dnscrypt-proxy
│   │   └── dnscrypt-proxy.toml -- dnscrypt-proxy config
│   └── portage
│       ├── make.conf
│       ├── make.conf (lto)
│       └── package.use
│           └── 00cpuflags
├── .inputrc -- bash config: controls
├── kernel
│   └── 4.19.72-gentoo-VALLEY-config
├── .mozilla
│   └── PROFILE
│       └── chrome
│           ├── userChrome.css -- sexify yo browser
│           └── userContent.css -- sexify yo web pages
├── .mpd
│   └── mpd.conf
├── .mpdscribble
│   └── mpdscribble.conf
├── .ncmpcpp
│   ├── config
│   └── config-lyrics
├── README.md
├── scripts
│   ├── art.sh -- used in ncmpcpp config for extracting/copying album art to /tmp/cover.png
│   └── general -- a script I use for general keybindings
├── .tmux.conf
├── .vimrc -- vim config
├── .xinitrc -- xinit config, used for startx
├── .xmonad
│   └── xmonad.hs -- xmonad config
├── .Xresources -- sexify yo Xresource-compatible apps
└── Windows
    └── keybindings.ahk -- autohotkey script to set up global keybindings on Windows
36 directories, 79 files
```
