## Set DPI to 96.
xrandr --dpi 96 &
## Toggle numlock.
numlockx &
## Merge Xresources.
xrdb -merge ~/.Xresources &
## Start unclutter, set timer to 3 seconds, and hide mouse in root window as well.
unclutter -idle 3 -root &
## Disable all the screen blanking and turning off shit.
xset -dpms s off s noblank &
# Set keyboard repeat rate.
xset r rate 200 60 &
# Set the wallpaper
feh --bg-fill -d -r -z /mnt/ehdd/Pictures/wallpapers &
# Start the compositor.
picom --backend glx --vsync --refresh-rate 60 --experimental-backends --no-fading-openclose -b &
## Launch Openbox.
# exec ck-launch-session dbus-launch --sh-syntax --exit-with-session openbox-session
## Launch LeftWM.
#exec dbus-launch --sh-syntax --exit-with-session leftwm
## Launch herbstluftwm
exec dbus-launch --sh-syntax --exit-with-session herbstluftwm
