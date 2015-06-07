#!/bin/sh
if [ -e GIT_URL ];then
	exit
else
	cd /etc
	if [ ! -e /etc/.git ];then
	git config --system user.name "GIT_USER"
	git config --system user.email "GIT_MAIL"
	git config --system core.editor "nano"
	git config --system http.sslverify false
	etckeeper init
	fi
	mkdir -p GIT_URL
	git init --bare GIT_URL
	cd /etc && git remote add -f origin GIT_URL
	# remove hard links as they should not be needed ... for now git cannot handle hard links
	git rm -f terminfo/v/vt220
	git rm -f terminfo/v/vt200
	git commit -m "initial commit"
	git push origin master
	rm /var/update/.newimage
fi

