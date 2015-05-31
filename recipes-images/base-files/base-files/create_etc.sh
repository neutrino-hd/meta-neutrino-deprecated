#!/bin/sh
if [ -f /var/update/.newimage ];then
	if [ -e GIT_URL ];then
		exit
	else
	cd /etc
	git config --global user.name "GIT_USER"
	git config --global user.email "GIT_MAIL"
	git config --global core.editor "nano"
	git config --global http.sslverify false
	etckeeper init
	mkdir -p GIT_URL
	git init --bare GIT_URL
	cd /etc && git remote add -f origin GIT_URL
	git commit -m "initial commit"
	git push origin master
	rm /var/update/.newimage
	fi
fi
