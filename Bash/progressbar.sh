#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#
ver="0.0.2"

function ProgressBar {
    let progres=(${1}*100/${2}*100)/100
    let done=(${progres}*4)/10
    let left=40-$done
    fill=$(printf "%${done}s")
    empty=$(printf "%${left}s")
    printf "\rWait : [${fill// /#}${empty// /-}] ${progres}%%"
}

start=1
end=100

for number in $(seq ${start} ${end})
do
    sleep 0.05
    ProgressBar ${number} ${end}
done
printf '\nFinished!\n'
exit 0

# end script
