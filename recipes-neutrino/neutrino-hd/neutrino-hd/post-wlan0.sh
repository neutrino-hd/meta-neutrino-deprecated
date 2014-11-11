#!/bin/sh
echo Stopping wlan0
 
/usr/sbin/wpa_cli terminate
sleep 2
