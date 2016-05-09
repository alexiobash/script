#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#

# definisce quanti annunci prelevare
feed=5
verde="\033[1;32m"
reset="\033[0m"
bianco="\033[1;37m"
blu="\033[1;34m"

titles=`wget -q -O- http://www.archlinux.it/forum/feed.php?f=15 | grep Notizie | sed -e 's/<[a-zA-Z\/][^>]*>//g' | sed -e 's/\[CDATA\[//g' | sed -e 's/\]//g' | sed -e 's/<\!//g' | sed -e 's/>//g' | sed -e 's/Notizie \•\ //g' | grep -v "^$"`
links=`wget -q -O- http://www.archlinux.it/forum/feed.php?f=15 | grep "<link href=" | grep -v "index.php" | sed -e 's/<link \href\=\"//g' | sed -e 's/\"\/>//g'`

	clear

for i in $(seq 1 $feed)
do
	titol=`echo "$titles" | sed -n "$i"p`
	echo -e ""$verde"Titolo News:"$bianco" $titol"$reset""
	linknews=`echo "$links" | sed -n "$i"p`	
	echo -e ""$blu"Link della News:"$bianco" $linknews"$reset""
	echo -e ""$verde"Recupero il testo..."$bianco""
	text=`wget -q -O- "$linknews" | grep "<div class" | sed -e 's/<[a-zA-Z\/][^>]*>//g' | grep -v "Rispondi al messaggio" | grep -v "Powered by phpBB"`
	echo $text | grep -v "^$"
	echo -e "$reset"
done 
