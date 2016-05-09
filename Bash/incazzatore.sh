#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#

while true
do
	bestemmia=$(curl -s www.santiebeati.it/$(</dev/urandom tr -dc A-Z|head -c1)/|grep tit|cut -d'>' -f5|cut -d'<' -f1|shuf -n1 | grep -vi "Binary")
	echo $bestemmia
	if [[ ! -z $bestemmia ]]; then mplayer -really-quiet -ao alsa "http://translate.google.com/translate_tts?tl=it&q=Mannaggia San $bestemmia" 2>/dev/null; fi
	sleep 2
done

# end script
