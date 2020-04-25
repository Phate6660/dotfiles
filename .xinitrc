## Set DPI to 96.
xrandr --dpi 96 &
## Toggle numlock.
numlockx &
## Merge Xresources.
xrdb -merge ~/.Xresources &
## Start Compton.
compton --vsync opengl --backend glx -o 1 -i 1 -e 1 --no-fading-openclose --refresh-rate 60 -CGb &
## Start unclutter, set timer to 3 seconds, and hide mouse in root window as well.
unclutter -idle 3 -root &
## Disable all the screen blanking and turning off shit.
xset -dpms s off s noblank &
## Set mouse cursor, not usually required unless using a WM like bspwm.
xsetroot -cursor_name left_ptr &
## Start screen saver and locker.
xscreensaver -no-splash &
## Restore wallpapers.
# nitrogen --restore &
## Launch Openbox.
# exec ck-launch-session dbus-launch --sh-syntax --exit-with-session openbox-session
## Launch bspwm.
# exec ck-launch-session dbus-launch --sh-syntax --exit-with-session bspwm
## Launch EXWM
# Set keyboard repeat rate.
xset r rate 200 60
# Finally start Emacs
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session emacs
