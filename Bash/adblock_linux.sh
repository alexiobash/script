#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://www.alexiobash.com
#

if [[ $UID != 0 ]];then exit 1; fi

case $1 in
	start)
		if [[ ! -f /etc/hosts.original ]]; then cp -p /etc/hosts /etc/hosts.original; fi
		cat /etc/hosts.original | grep -v "End of file" > /etc/hosts
		echo -e "\n\n# Adblock list server by http://someonewhocares.org" >> /etc/hosts
		curl -s http://someonewhocares.org/hosts/hosts | grep "Last updated:" >> /etc/hosts 
		echo "" >> /etc/hosts 
		curl -s http://someonewhocares.org/hosts/hosts | grep "127.0.0.1" | sed -e 's/#127.0.0.1/127.0.0.1/g' | sed '/^#/ d' >> /etc/hosts
		echo -e "\n# End of file" >> /etc/hosts
		exit 0
	;;
	stop)
		if [[ ! -f /etc/hosts.original ]]; then exit 1; fi
		cat /etc/hosts.original > /etc/hosts
		exit 0
	;;
	*) echo "usage: start|stop";;
esac

#end script
