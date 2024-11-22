#!/bin/sh

. /home/oracle/.bashrc

date >> getinfo.log

LOG=`date +"%d%m%y%H%M%S"`.log
EMAIL="dsanmaci@emeal.nttdata.com"
TODAY=`date +%A", "%B" "%d", "%Y`

OIFS=$IFS
IFS="
"
NIFS=$IFS

function getInfo {
INFO=`$OGG_HOME/ggsci << EOF
info all
exit
EOF`
}
function readInfo {
for line in $INFO
do
if [[ $(echo "${line}"|egrep 'XXX' >/dev/null;echo $?) = 0 ]]
then
NAME=$(echo "${line}" | awk -F" " '{print $3}')
STATS=$(echo "${line}" | awk -F" " '{print $2}')
TYPE=$(echo "${line}" | awk -F" " '{print $1}')

printf "The process ${NAME} is ${STATS}" | mailx -s "[${DATABASE}] ${TYPE}:${NAME} - STATUS: ${STATS} - ${TODAY}." ${EMAIL}

fi
done
}

getInfo
readInfo
