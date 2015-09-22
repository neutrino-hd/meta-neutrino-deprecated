#!/bin/sh
#
# Home Sharing script
#
# May only be used if and only if it doesn't violate your cable or sat
# providers terms of service.
#
# Inactive by default. Fill the gaps, and link to /etc/rc5.d to activate.

PATH=/bin:/usr/bin
DAEMON=doscam
DAEMON_OPTS="-b"
DAEMON1=osemu
DAEMON1_OPTS="-a user:password -p 11000 -b"

cam_start() {
	if [ -e /usr/bin/$DAEMON1 ];then
	echo -n "Starting $DAEMON1 "
	$DAEMON1 $DAEMON1_OPTS
	sleep 2
	fi
	echo -n "Starting $DAEMON "
	$DAEMON $DAEMON_OPTS
	echo -e "\ndone."
}

cam_stop() {
	if [ -e /usr/bin/$DAEMON1 ];then
	echo -n -e "Stopping $DAEMON1\n"
	killall $DAEMON1
	fi
	echo -n "Stopping $DAEMON "
	killall $DAEMON
	echo -e "\ndone."
}

case $1 in
start)
	cam_start
	;;
stop)
	cam_stop
	;;
restart)
	cam_stop
	sleep 2
	cam_start
	sleep 2
	pzapit -rz
	;;
init)
	sleep 2
	cam_start
	if grep lastChannelTVScrambled=true /etc/neutrino/config/zapit/zapit.conf
	then
		sleep 5
		pzapit -rz
	fi
esac
