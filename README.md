# windesktop
use applications as cinnamon background

I know nothing about Cinnamon coding, Linux de structure, C coding or Bash coding, so feel free to suggest better ways to do things

- this script sets a window type to application and also moves it behind nemo window, obviously only works on X
- uses some code as example from lrewega/xwinwrap
- requires xprop, wmctrl, mpv, socat, xwininfo to run without modifying the script
- add windesktop.sh as a startup application to have it enabled on startup
- if something goes wrong, run 'killall windesktop.sh'
- you may want to use https://github.com/valgusk/cinnamon-bg Cinnamon extension if you want expo and ovrview support
