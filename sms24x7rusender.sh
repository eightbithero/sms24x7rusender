#!/bin/sh

theta=1800 # 30 min in seconds

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <message> <login> <password> [<phone>]" >&2
  exit 1
fi

logfile="/var/log/smsnotifier.log"

if [ ! -f $logfile ]; then

echo "Create logfile:\n\
sudo touch $logfile\n\
sudo chmod 0776 $logfile";

exit 1

fi

lockdir="/var/lock/smsnotifier/"

if [ ! -d $lockdir ]; then

echo "Create lockfile:\n\
sudo mkdir -p $lockdir\n\
sudo chmod -R 0776 $lockdir";

exit 1;
	
fi

message=$1
login=$2
password=$3
phones=$4

if which md5sum >/dev/null; then
	lockfile=$lockdir`echo -n $1 | md5sum | awk '{print $1}'``echo ".lock"`
else 
	lockfile=$lockdir`echo -n $1 | md5 | awk '{print $1}'``echo ".lock"`
fi

if [ -f $lockfile ]; then
	filemtime=`stat -c %Y $lockfile 2>/dev/null`;
	if [ -z $filemtime ]; then
		filemtime=`stat -f %m $lockfile 2>/dev/null`;
	fi
	currtime=`date +%s`;
	diff=$(($currtime - $filemtime));
	if [ $diff -lt $theta ]; then
		exit 0
	fi
fi

touch $lockfile

sendresult=`curl -X POST --silent -d "method=push_msg&format=json&api_v=1.1&email=$login&password=$password&text=$message&phones=$phones" https://api.sms24x7.ru/ 2>&1 | grep -Po '(?<="err_code":)(\d)+'`

if [ $sendresult -ne 0 ]; then
	#https://outbox.sms24x7.ru/api_manual/errors.html
	echo "error at sending message code: $sendresult" >> $logfile
	rm -f $lockfile
	exit 1
fi

exit 0
