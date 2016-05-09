#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://www.alexiobash.com
#
ver="0.0.1 beta"
carat=20 #caratteri da utilizzare
username=root
from_mail="from@domain"
to_mail="to@domain"
hostname=$(hostname)

# cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1
# cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@$&*+?' | fold -w 12 | head -n 1
# cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()+[]|:<>?=' | fold -w $carat | grep -i '[_!@#$%^&*()+|:<>?=]' | head -n 1
new_passwd_user=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()+[]|:<>?=' | fold -w $carat | head -n 1)
passwd $username <<EOF
$new_passwd_user
$new_passwd_user
EOF
echo -e "The new password for $hostname as changed in:\nUsername: $username\nPassword: "$new_passwd_user"" | mail -r "$from_mail" -s "*** New Password $hostname ***" -S smtp="$relay" $to_mail 
exit
