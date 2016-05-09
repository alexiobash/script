#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#

prg=$(whereis xdotool | awk '{print $2}')
if [ -z "$prg" ]; then echo "please install xdotool"; exit; fi

if [ -t 0 ]; then stty -echo -icanon time 0 min 0; fi

key=''

while [ "x$key" = "x" ]; do
	position=$(xdotool getmouselocation 2>/dev/null)
	assex=$(echo $position | awk '{print $1}'| sed -e 's/x://g')
	assey=$(echo $position | awk '{print $2}'| sed -e 's/y://g')
	clear
	echo -e "X: $assex Y: $assey"
	echo "Press \"c\" to caputure"
	read key
done

if [ -t 0 ]; then stty sane; fi

clear
echo -e "X: $assex \nY: $assey"
exit

# end script
