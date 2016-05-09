#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#
# IT: https://alexiobash.com/ottenere-il-proprio-ip-pubblico-da-shell/
#

ver="2.2"
attual_ip=`cat ~/.my_ip_address`
to_mail=""
from_mail=""
relay="iprelay:port"
data=`date +%d-%m-%y_%H:%M`

current_ip=`curl -s ip.alexiobash.com`
echo $current_ip > ~/.my_ip_address

if [ $attual_ip != $current_ip ]; then 
	echo $data - $current_ip >> ~/.my_ip_address_history
	echo -e "The Pubblic IP are changed in $current_ip"| mail -r "$from_mail" -s "Current IP Address" -S smtp="$relay" $to_mail
fi
