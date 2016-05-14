#!/bin/sh

DO_REBOOT=0

# Update Kernel or bootloader, if available
if [ -f /var/update/vmlinux.ub.gz ]; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i kernel /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i kernel /proc/mtd | cut -f 0 -s -d :`
	fi
	echo Updating kernel on device $DEV .....
	/usr/sbin/flash_eraseall /dev/$DEV && /bin/cat /var/update/vmlinux.ub.gz > /dev/$DEV
	rm /var/update/vmlinux.ub.gz
	DO_REBOOT=1
fi

if [ -f /var/update/u-boot.bin ]; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i u-boot /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i u-boot /proc/mtd | cut -f 0 -s -d :`
	fi
	echo Updating u-boot on device $DEV .....
	/usr/sbin/flash_eraseall /dev/$DEV && /bin/cat /var/update/u-boot.bin > /dev/$DEV
	rm /var/update/u-boot.bin
	DO_REBOOT=1
fi

if [ -f /var/update/uldr.bin ]; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i uldr /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i uldr /proc/mtd | cut -f 0 -s -d :`
	fi
	echo Updating loader on device $DEV .....
	/usr/sbin/flash_eraseall /dev/$DEV && /bin/cat /var/update/uldr.bin > /dev/$DEV
	rm /var/update/uldr.bin
	DO_REBOOT=1
fi

if [ -f /var/update/.erase_env ]; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i env /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i env /proc/mtd | cut -f 0 -s -d :`
	fi
	echo cleaning env on device $DEV .....
	/usr/sbin/flash_eraseall /dev/$DEV
	rm /var/update/.erase_env
	DO_REBOOT=1
fi

if [ $DO_REBOOT = 1 ]; then
	echo Reboot...
	sync
	sleep 2
	/sbin/reboot -f
fi
