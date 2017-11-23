#!/bin/bash
source ~/.bashrc
cd "$( dirname "${BASH_SOURCE[0]}" )"

# killall nemo-desktop
# nemo-desktop & #--force-desktop &
until $(echo xwininfo -name Desktop)|grep "IsViewable"; do :; done
did=$($(echo xwininfo -name Desktop)|grep "Window id:"|sed 's/.*\(0x\w*\).*/\1/')





# chromium-browser --kiosk "localhost" &
#mplayer -fs --loop=0 --nosound /home/pew/Videos/coub4.mp4 &
# mplayer -fs --loop=0 --nosound /home/pew/Videos/car.mp4  -aspect 16/9 &

# mpv  --fs --no-keepaspect --no-keepaspect-window --no-border  --geometry=1920x1080+0+0 --no-osc --loop --no-audio ./videos/croftmanor.avi  --video-aspect 16/9 >/dev/null  &  
vidfile="questions_slide_center3.wmv"

# cp ./videos/$vidfile /home/pew/ramdisk/$vidfile
mpv --hwdec=auto --fs --no-keepaspect --no-keepaspect-window --no-border  --geometry=1440x900+0+0 --really-quiet  --no-osc --loop --no-audio  ./videos/$vidfile --input-ipc-server=/tmp/mpvsocket --video-aspect 16/9 &

# mpv  --fs --no-keepaspect --no-keepaspect-window --no-border  --geometry=1920x1080+0+0 --no-osc --loop --no-audio ./videos/chain.mp4  --video-aspect 16/9 >/dev/null  &  
# vlc --loop --no-interact --fullscreen --video-title-show ./videos/chain.mp4 &
# gnome-system-monitor &


# mplayer -fs --loop=0 --nosound /home/pew/Videos/coolboub.mp4 &
# /usr/lib/xscreensaver/skytentacles -speed 0.3 -texture -cel -fs&
# chromium-browser --kiosk "https://www.shadertoy.com/embed/lsfGzr?gui=false&t=10&paused=false&muted=true" &
# MdB3Dd, XdlSDs, 4sf3zX, lsfGzr, 4dcGW2, Xsf3z2, ldlXRS, ldB3Wd, 4t23RR, lsXGz8, XdBSzG
# google-chrome "https://www.shadertoy.com/embed/Msl3Rr?gui=false&t=10&paused=false&muted=true" --user-data-dir=/tmp/chrome2/  &
# firefox -P fullscreen "https://www.shadertoy.com/embed/Msl3Rr?gui=false&t=10&paused=false&muted=true"  &

pid=$!
echo ">>>>>>>>>> PID: $pid <<<<<<<<<<<<" 

if ! [ $pid ]; then  
	echo "PID is empty! exiting!" 
	exit 
fi

clean_up () {
	echo "exiting\n"
	kill $pid
	
	exit
}


trap clean_up SIGHUP SIGINT SIGTERM

until $(echo wmctrl -lp)|grep " $pid "; do 

	echo 'waiting for window' 
	echo $(wmctrl -lp) 
done


wid=$($(echo wmctrl -lp)|grep " $pid "|sed 's/.*\(0x\w*\).*/\1/')

until $(echo xwininfo -id $wid)|grep "IsViewable"; do :; done

# wid=$($(echo xwininfo -name mplayer2)|grep "Window id:"|sed 's/.*\(0x\w*\).*/\1/')
# wmctrl -i -r $wid -b add,maximized_vert,maximized_horz


echo ">>>>>>>>>>>> window: $wid, desktop handler: $did, PID: $pid <<<<<<<<<<<<<<" 

./windesktop $wid $did
#
# ./windesktop $did
# nemo -n --force-desktop &

echo "started" 

{
	IS_FULLSCREEN=0
	while :
	do
		WM_FLAGS=$(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) _NET_WM_STATE)
		echo $WM_FLAGS | grep _NET_WM_STATE_FULLSCREEN --quiet
		WM_FS=$?
		echo $WM_FLAGS | grep _NET_WM_STATE_MAXIMIZED_VERT --quiet
		WM_VT=$?
		echo $WM_FLAGS | grep _NET_WM_STATE_MAXIMIZED_HORZ --quiet
		WM_HZ=$?

		if [ $WM_FS -eq 0 ] || ([ $WM_VT -eq 0 ] && [ $WM_HZ -eq 0 ]); then
			if [ $IS_FULLSCREEN -eq 0 ]; then
				IS_FULLSCREEN=1
				echo " full screen detected, pausing background"
				echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket
			fi
		else
			if [ $IS_FULLSCREEN -eq 1 ]; then
				IS_FULLSCREEN=0
				echo " full screen no longer detected, unpausing background"
				echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpvsocket
			fi
		fi
		sleep 5
	done
}&


wait $pid


# #!/bin/bash
# WINDOW=$(echo $(xwininfo -id $(xdotool getactivewindow) -stats | \
#                 egrep '(Width|Height):' | \
#                 awk '{print $NF}') | \
#          sed -e 's/ /x/')
# SCREEN=$(xdpyinfo | grep -m1 dimensions | awk '{print $2}')
# if [ "$WINDOW" = "$SCREEN" ]; then
#     exit 0
# else
#     exit 1
# fi