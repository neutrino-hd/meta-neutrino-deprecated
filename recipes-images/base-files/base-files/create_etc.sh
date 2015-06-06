#!/bin/sh
if [ -e GIT_URL ];then
	exit
else
	cd /etc
	if [ -e .git ];then fi
	else
	git config --system user.name "GIT_USER"
	git config --system user.email "GIT_MAIL"
	git config --system core.editor "nano"
	git config --system http.sslverify false
	etckeeper init
	fi
	mkdir -p GIT_URL
	git init --bare GIT_URL
	cd /etc && git remote add -f origin GIT_URL
	git commit -m "initial commit"
	git push origin master
fi

