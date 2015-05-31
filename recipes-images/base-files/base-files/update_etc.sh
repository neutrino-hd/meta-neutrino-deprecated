#!/bin/sh

if [ -f /var/update/.newimage ];then
	if [ -e GIT_URL ];then
		git config --global user.name "GIT_USER"
		git config --global user.email "GIT_MAIL"
		git config --global core.editor "nano"
		git config --global http.sslverify false
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
