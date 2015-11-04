#!/bin/sh
export PATH=/sbin:/bin:/usr/bin:/usr/sbin

if [ -e /var/update/uImage ] ; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i kernel /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i kernel /proc/mtd | cut -f 0 -s -d :`
	fi
	echo "Update KERNEL..."
	flash_eraseall /dev/$DEV && cat /var/update/uImage > /dev/$DEV
	rm /var/update/uImage
	DO_REBOOT=1
else
	echo "Skipping Update KERNEL"
fi

if [ $DO_REBOOT = 1 ]; then
	echo Reboot...
	sync
	sleep 2
	reboot -f
fi
