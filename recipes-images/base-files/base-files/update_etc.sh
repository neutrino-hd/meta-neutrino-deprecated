#!/bin/sh

if [ -f /var/update/.newimage ];then
	if [ -e GIT_URL ];then
		cd /etc && etckeeper init
		git remote add origin GIT_URL
		git fetch -a
		git reset --hard origin/master
		rm /etc/ssh/ssh_host*
		rm /var/update/.newimage
		echo Reboot...
		sync
		sleep 2
		reboot -f
	fi
fi
