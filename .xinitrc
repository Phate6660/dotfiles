#!/bin/sh

# Set dpi to 96
xrandr --dpi 96 &

# Merge xresources
xrdb -merge ~/.Xresources &

# Start dunst
if pgrep dunst; then $(killall dunst && dunst &); else $(dunst &); fi &

# Mount usb devices
if pgrep udiskie; then $(killall udiskie && udiskie &); else $(udiskie &); fi &

# Set the wallpaper
hsetroot -full ~/wallpaper6.png &

# Start xscreensaver
xscreensaver &

# Run my greeter script
greeting &

# Run unclutter
if pgrep unclutter; then $(killall unclutter && unclutter --timeout 3 --fork &); else $(unclutter --timeout 3 --fork &); fi &

# greenclip
if pgrep greenclip; then $(killall greenclip && greenclip daemon &); else $(greenclip daemon &); fi &

# numlock on
numlockx &

# ckb-next (keyboard drivers)
ckb-next &

# start xmonad
exec xmonad
