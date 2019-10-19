/home/valley/.local/bin/wal -R &
numlockx &
xrandr --dpi 96 &
xrdb -merge ~/.Xresources &
compton --vsync opengl --backend glx -o 1 -i 1 -e 1 --no-fading-openclose --refresh-rate 60 -CGb &
xautolock -time 10 -locker slock &
unclutter -idle 3 -root &
xset -dpms s off s noblank &
xsetroot -cursor_name left_ptr &
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session bspwm
