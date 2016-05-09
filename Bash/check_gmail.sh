#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#
# IT: https://alexiobash.com/script-controllare-la-posta-gmail-in-bash/
ver="3.0"
# ----------------------------------
username=""
password=""
# ----------------------------------
verde="\033[1;32m"
reset="\033[0m"
bianco="\033[1;37m"
blu="\033[1;34m"
url="https://mail.google.com/mail/feed/atom"
new_mail=$(curl --silent --url "$url" --user $username:$password | sed -r 's/.*<fullcount>|<\/fullcount>.*//g')

case $new_mail in
	0)
		echo -e ""$verde"==>"$bianco" No New Mail"$reset" \n"
	;;
	*)
		echo -e ""$verde"==> "$blu"$new_mail"$bianco" New Mail:"$reset" \n"
		for i in $(seq 1 $new_mail)
		do
			subject=`curl --silent --url "$url" --user $username:$password | sed -r 's/<title>/\'\n'/g' | grep -v "Gmail - Inbox" | grep -v "feed version" | sed -r 's/.*<title>|<\/title>.*//g' | sed -n "$i"p`
			name=`curl --silent --url "$url" --user $username:$password | sed -r 's/<name>/\'\n'/g' | grep -v "Gmail - Inbox" | grep -v "feed version" | sed -r 's/.*<name>|<\/name>.*//g' | sed -n "$i"p`
			mail=`curl --silent --url "$url" --user $username:$password | sed -r 's/<email>/\'\n'/g' | grep -v "Gmail - Inbox" | grep -v "feed version" | sed -r 's/.*<email>|<\/email>.*//g' | sed -n "$i"p`
			echo -e ""$verde"New Mail from:"$bianco" $name "$blu"<"$bianco""$mail""$blu">""$reset"
			echo -e ""$verde"Subject:"$bianco" $subject""$reset"
			echo -e ""
		done
	;;
esac
exit

# end script
