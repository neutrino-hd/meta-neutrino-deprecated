#!/bin/sh
 
echo Starting wlan0
 
/usr/sbin/wpa_cli terminate
sleep 1
 
/usr/sbin/wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf
#/usr/sbin/wpa_supplicant -D ipw -c /etc/wpa_supplicant.conf -i wlan0 -B
sleep 8
