#!/bin/sh
if [ -e GIT_URL ];then
	if [ ! -e /etc/gitconfig ];then
		git config --system user.name "GIT_USER"
		git config --system user.email "MAIL"
		git config --system core.editor "nano"
		git config --system http.sslverify false
	fi
        if [ "$(cd GIT_URL && git log --pretty=format:"%cd")" == "$(cd /etc && git log --pretty=format:"%cd")" ];then
                exit
        fi
	cd /etc && etckeeper init
	git remote add origin GIT_URL
	git fetch -a
	git reset --hard origin/master
	rm /etc/ssh/ssh_host*
	echo Reboot...
	sync
	sleep 2
	reboot -f
fi


