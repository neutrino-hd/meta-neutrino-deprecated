#!/bin/sh

GIT__URL='GIT_URL'
GIT_EXIST=$(echo $GIT__URL"/HEAD")

if [ -e $GIT_EXIST ];then
	if [ ! -e /etc/gitconfig ];then
		git config --system user.name "GIT_USER"
		git config --system user.email "MAIL"
		git config --system core.editor "nano"
		git config --system http.sslverify false
	fi
        if [ "$(cd $GIT__URL && git log -1 --pretty=format:"%cd")" == "$(cd /etc && git log -1 --pretty=format:"%cd")" ];then
                break
        else
		systemctl stop neutrino.service
                dt -t"writing back /etc remote"
                cd /etc && etckeeper init
                git remote add origin $GIT__URL
                git fetch -a
                git reset --hard origin/master
                rm /etc/ssh/ssh_host*
                dt -t"...done"
                sync
                sleep 2
                dt -t"rebooting"
                systemctl reboot
        fi
else
        dt -t"no remote found"
fi





