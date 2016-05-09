#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#
# GTK for rdesktop
# URL: https://alexiobash.com/client-gtk-per-rdesktop/
#
# install zenity and rdesktop
ver="0.0.5 beta"
OPT="-r clipboard"
NAME_DISK="SHARE"

error_msg () {
	zenity --error --text="Empty Value!!\nConnection abort!!"
}

saved_session () {
		NAMECONNECTION=$(zenity --entry --title="" --text="Connection Name:" --ok-label=Save)
		if [[ $? != 0 ]]; then exit 1; fi
		if [[ -z $NAMECONNECTION ]]; then NAME="$ipaddress"; else NAME="$NAMECONNECTION"; fi
		echo -e "$command_exec" > ~/.rdesktop-gtk/"$NAME".connect
		exit 0
}

connection_srv () {
	case $resolution in
		FullScreen) 
			case $password in
				null)
					case $storage in
						null)
							case $domain in
								null) command_exec="rdesktop -f -u "$username" -k "$keymap" "$ipaddress" "$OPT"";;
								*) command_exec="rdesktop -f -d "$domain" -u "$username" -k "$keymap" "$ipaddress" "$OPT"" ;;
							esac	
						;;
						*)
							case $domain in
								null) command_exec="rdesktop -f -u "$username" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
								*) command_exec="rdesktop -f -d "$domain" -u "$username" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
							esac
						;;
					esac
				;;
				*)
					case $storage in
						null)
							case $domain in
								null) command_exec="rdesktop -f -u "$username" -p "$password" -k "$keymap" "$ipaddress" "$OPT"" ;;
								*) command_exec="rdesktop -f -d "$domain" -u "$username" -p "$password" -k "$keymap" "$ipaddress" "$OPT"" ;;
							esac
							
						;;
						*)
							case $domain in
								null) command_exec="rdesktop -f -u "$username" -p "$password" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
								*) command_exec="rdesktop -f -d "$domain" -u "$username" -p "$password" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
							esac
						;;
					esac				
				;;
			esac
		;;
		*) 
			case $password in
				null)
					case $storage in
						null)
							case $domain in
								null) command_exec="rdesktop -g "$resolution" -u "$username" -k "$keymap" "$ipaddress" "$OPT"" ;;
								*) command_exec="rdesktop -g "$resolution" -d "$domain" -u "$username" -k "$keymap" "$ipaddress" "$OPT""	;;
							esac
						;;
						*)
							case $domain in
								null) command_exec="rdesktop -g "$resolution" -u "$username" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
								*) command_exec="rdesktop -g "$resolution" -d "$domain" -u "$username" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
							esac
						;;
					esac
				;;
				*)
					case $storage in
						null)
							case $domain in
								null) command_exec="rdesktop -g "$resolution" -u "$username" -p "$password" -k "$keymap" "$ipaddress" "$OPT"" ;;
								*) command_exec="rdesktop -g "$resolution" -d "$domain" -u "$username" -p "$password" -k "$keymap" "$ipaddress" "$OPT"" ;;
							esac
						;;
						*)
							case $domain in
								null) command_exec="rdesktop -g "$resolution" -u "$username" -p "$password" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
								*) command_exec="rdesktop -g "$resolution" -d "$domain" -u "$username" -p "$password" -k "$keymap" -r disk:"$NAME_DISK"="$storage" "$ipaddress" "$OPT"" ;;
							esac
						;;
					esac				
				;;
			esac
			
		;;
	esac
	case $savedses in
		Yes)
			$command_exec
			saved_session
			exit 0
		;;
		*) 
			$command_exec
			exit 0
		;;
	esac
	
}

menu_main () {
	RESULT=$(zenity --title="RDesktop GTK" --text="Connection Setting" --ok-label="Connect" --cancel-label="Exit" --forms --add-entry="IP Address*:" --add-entry="Username*:" --add-entry="Domain:" --add-password="Password:" --add-combo="Resolution*:" --combo-values="800x600|1024x768|FullScreen" --add-combo="Storage:" --combo-values="/mnt|/home|/|/opt|/var|/usr" --add-combo="Keymap*:" --combo-values="it|en_us|de" --add-combo="Save:" --combo-values="Yes|No")
	if [[ -z $RESULT ]]; then exit 1; fi
	VALUE_ELAB="$(echo $RESULT | sed -e 's/|||/ . null /g' | sed -e 's/||/ null /g' | sed -e 's/| |/ null /g')"
	VALUE="$(echo $VALUE_ELAB | sed -e 's/|/ /g')"
	echo $RESULT
	echo $VALUE
	ipaddress=$(echo $VALUE | awk '{print $1}')
	username=$(echo $VALUE | awk '{print $2}')
	domain=$(echo $VALUE | awk '{print $3}')
	password=$(echo $VALUE | awk '{print $4}') 		
	resolution=$(echo $VALUE | awk '{print $5}')	
	storage=$(echo $VALUE | awk '{print $6}') 		
	keymap=$(echo $VALUE | awk '{print $7}')
	savedses=$(echo $VALUE | awk '{print $8}')
	if [[ (-z "$ipaddress") || (-z "$username") || (-z "$resolution") || (-z "$keymap") ]]; then error_msg; menu_main; else connection_srv; fi
}

start_menu () {
	CONNECT=$(zenity --title="RDesktop GTK" --text="Select Connection" --ok-label="Open" --cancel-label="Exit" --add-combo="Connection:" --combo-values="NEW|$CONNECTION" --forms)
	result_connect=$?
	if [[ -z $CONNECT ]]; then exit 0; fi
	case $CONNECT in
		NEW) menu_main;;
		*)
			COMMAND=$(cat ~/.rdesktop-gtk/"$CONNECT".connect)
			$COMMAND
		;;
	esac
}

check_folder () {
	if [[ -d ~/.rdesktop-gtk ]]; then
		cd ~/.rdesktop-gtk
		CONNECTION=$(ls -m *.connect | sed -e 's/.connect//g' | sed -e 's/,/|/g' | sed -e 's/ //g')
	else
		CONNECTION=""
		mkdir ~/.rdesktop-gtk 
	fi
}

check_folder
start_menu

exit 0
# End Script
