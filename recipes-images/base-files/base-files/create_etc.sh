#!/bin/sh
if [ -e GIT_URL ];then
	exit
elif mountpoint -q /media/sda1;then
	cd /etc
	if [ ! -e /etc/gitconfig ];then
	git config --system user.name "GIT_USER"
	git config --system user.email "MAIL"
	git config --system core.editor "nano"
	git config --system http.sslverify false
	etckeeper init
	fi
	mkdir -p GIT_URL
	git init --bare GIT_URL
	cd /etc && git remote add -f origin GIT_URL
	git commit -m "initial commit"
	git push origin master
else
        echo "no mounted media found"
fi
