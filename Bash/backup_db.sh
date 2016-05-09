#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://www.alexiobash.com
#

data=$(date +%F)
giorno_set=$(date +%a)
mail_to="destinatari" # destinatario
mail_from="mittente" # mittente
relay="ip:port" # relay di posta
DB=() #inserire nomi db separati da spazio
password_db="" # passord db root
backup_dir="" # destinazione dei backup


send_mail_ok () {
	echo "Il backup del database $db e' stato completato con successo." | mail -r "$mail_from" -s "BACKUP DB $db" -S smtp="$relay" $mail_to
}

send_mail_ko () {
	echo "ERRORE nel backup del database: $db" | mail -r "$mail_from" -s "* ERRORE * BACKUP DB $db" -S smtp="$relay" $mail_to
}

backup_db () {
	for db in "${DB[@]}"; do
		if [ "${db}" = "${db#!}" ]; then
			mysqldump -u root -p"$password_db" --lock-tables "$db" > $backup_dir/dump_"$db"_"$data"_"$giorno_set".sql
			case $? in
				0) gzip $backup_dir/dump_"$db"_"$data"_"$giorno_set".sql; send_mail_ok;;
				*) send_mail_ko;;
			esac
		fi
	done
}

rotate_log () {
	for db in "${DB[@]}"; do
		if [ "${db}" = "${db#!}" ]; then
			file_del=$(ls $backup_dir/dump_"$db"_* | grep $giorno_set)
			if [ !-f "$file_del" ]; then file_error=ok; else rm -f "$file_del"; fi
		fi	
	done
}

rotate_log
backup_db
