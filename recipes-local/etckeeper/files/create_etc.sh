#!/bin/sh

GIT__URL='GIT_URL'
GIT_EXIST=$(echo $GIT__URL"/HEAD")
DEST=$(echo $GIT__URL | cut -d"/" -f1,2,3)

if [ -e $GIT_EXIST ];then
	exit
elif mountpoint -q $DEST;then
	cd /etc
	if [ ! -e /etc/gitconfig ];then
	git config --system user.name "GIT_USER"
	git config --system user.email "MAIL"
	git config --system core.editor "nano"
	git config --system http.sslverify false
	fi
	dt -t"creating /etc remote"	
	etckeeper init
	mkdir -p $GIT__URL
	git init --bare $GIT__URL
	cd /etc && git remote add -f origin $GIT__URL
	git commit -m "initial commit"
	git push origin master
else
        echo "no mounted media found"
fi
