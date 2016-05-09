#!/bin/bash
strings=$(/usr/bin/le-renew storage.alexiobash.com)
day_left=$(echo $strings | sed -r 's/.*\(| days.*//g')
quota=30

if [[ "$day_left" -lt "$quota" ]]; then
	echo -e "Ciao Alessio,\nil certificato SSL di storage.alexiobash.com scade tra $count giorni.\nPer rinnovare il certificato lascia dal server:\n\n# cd /root/letsencrypt\n#./letsencrypt-auto --renew-by-default\n\nServer storage.alexiobash.com"| mail -r "storage.alexiobash.com" -s "Scadenza Certificato SSL Letsencrypt tra $quota giorni" -S smtp="192.168.0.105:25" me@alexiobash.com
fi
