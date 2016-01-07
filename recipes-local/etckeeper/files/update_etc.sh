#!/bin/sh

GIT__URL='GIT_URL'

if [ -e $GIT__URL ];then
	if [ ! -e /etc/gitconfig ];then
		git config --system user.name "GIT_USER"
		git config --system user.email "MAIL"
		git config --system core.editor "nano"
		git config --system http.sslverify false
	fi
        if [ "$(cd $GIT__URL && git log -1 --pretty=format:"%cd")" == "$(cd /etc && git log -1 --pretty=format:"%cd")" ];then
                exit
        fi
	cd /etc && etckeeper init
	git remote add origin $GIT__URL
	git fetch -a
	git reset --hard origin/master
	rm /etc/ssh/ssh_host*
	echo Reboot...
	sync
	sleep 2
	reboot -f
fi


