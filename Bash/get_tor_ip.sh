#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#
# IT: https://alexiobash.com/bloccare-lutilizzo-di-tor-con-squid/
path_squid=/etc/squid
dir_temp=/tmp
rm -f $dir_temp/Tor_ip_list_ALL.csv
wget http://torstatus.blutmagie.de/ip_list_all.php/Tor_ip_list_ALL.csv -O $dir_temp/Tor_ip_list_ALL.csv
uniq $dir_temp/Tor_ip_list_ALL.csv > $path_squid/iptor.txt
dos2unix $path_squid/iptor.txt
squid -k reconfigure
exit 0
