## Set HDMI to primary output, VGA to secondary.
xrandr --output VGA-0 --mode 1440x900 --pos 1366x0 --rotate normal --output HDMI-0 --primary --mode 1366x768 --pos 0x0 --rotate normal &
## Set DPI to 96 -- Yes, I know I can combine the two xrandr commands. I separated them on purpose.
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
nitrogen --restore &
## Launch Openbox.
# exec ck-launch-session dbus-launch --sh-syntax --exit-with-session openbox-session
## Launch bspwm.
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session bspwm
