#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#
# mailbomb.sh
ver="1.0.3"
RED="\033[1;31m"
NC="\033[0m"

type=telnet     		# definire se usare telnet o heirloom-mailx/postfix (comando mail)
#type=mail
relay=				# ip relay di posta
port=25				# porta relay
mail_to=""			# destinatario
mail_from=""			# mittente
subject="TEST MTA: $relay"	# oggetto della mail
message=""			# testo del messaggio
count=10			# numero di email da inviare
sleeping=0			# secondi di attesa tra un invio e un altro (0 disable)
	

for i in $(seq 1 $count)
do
	echo -e "\n[+] "$RED"::"$NC" Send Message Number "$RED"$i"$NC"\n" 
	case $type in
		telnet)
expect <<EOF
spawn telnet $relay $port
send "helo mail\r"
send "MAIL FROM:<$mail_from>\r"
send "RCPT TO:<$mail_to>\r"
send "DATA\r"
send "SUBJECT: $subject\r"
send "Message Number: $i\r"
send "$message\r"
send "\r"
send "Send by MailBomb $ver www.alexiobash.com\r"
send ".\r"
send "quit\r"
expect eof
EOF
		;;
		mail) echo -e "Message Number: $i\n$message\nSend by MailBomb $ver www.alexiobash.com" | mail -r "$mail_from" -s "$subject" -S smtp="$relay":"$port" "$mail_to";;
		*) echo "errore nel type: $type";;
	esac
	echo -e "\n"
	sleep $sleeping
done
exit 0
