#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://www.alexiobash.com
#
# cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1
# cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@$&*+?' | fold -w 12 | head -n 1
# cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()+[]|:<>?=' | fold -w $carat | grep -i '[_!@#$%^&*()+|:<>?=]' | head -n 1

ver="0.0.5"
dir_passwd=/opt/storage/backup/pluto/passwd
carat=12
username=alessio
new_passwd_user=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $carat | head -n 1`
sender_mail="alexiobash@gmail.com"
from_mail="server.pluto.adp@gmail.com"
relay="192.168.0.216"

expect <<EOF
spawn htdigest -c $dir_passwd/passwd_webdav Secret-Area $username
expect "New password:"
send "$new_passwd_user\r"
expect "Re-type new password:"
send "$new_passwd_user\r"
expect eof
exit
EOF

echo -e "This is a new Webdav Password: \nPassword: "$new_passwd_user" \nDon't delete this mail" | mail -r "$from_mail" -s "WebDav Credenzial" -S smtp="$relay" "$sender_mail"

exit
# end script
