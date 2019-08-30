wal -R                                                                                             # wal colorscheme
numlockx &                                                                                         # Turn on numlock
xrandr --dpi 96 &                                                                                  # Set dpi to 96
xrdb -merge ~/.Xresources &                                                                        # Merge .Xresources
compton --vsync opengl --backend glx -o 1 -i 1 -e 1 --no-fading-openclose --refresh-rate 60 -CGb & # Compton
xautolock -time 10 -locker slock &                                                                 # Start xautolock
unclutter -idle 3 -root &                                                                          # Start unclutter
greenclip daemon &                                                                                 # Start greenclip
greenclip clear &                                                                                  # Clear clipboard history
mpDris2 &                                                                                          # Start mpDris2
nohup server &                                                                                     # Start rust web server
xset -dpms s off s noblank &                                                                       # No screen blanking nor poweroff
xhost si:localuser:ff                                                                              # Allow ff to run firefox through localuser
pcmanfm -d &                                                                                       # pcmanfm in daemon mode
/usr/libexec/polkit-gnome-authentication-agent-1 &                                                 # fucking polkit bullshit -_-
nitrogen --restore &                                                                               # wallpapers
udiskie -aNT &                                                                                     # automount external storage devices
uxterm -e /home/valley/scripts/auto &                                                              # run auto script
exec ck-launch-session dbus-launch --exit-with-session dwm                                         # dwm
