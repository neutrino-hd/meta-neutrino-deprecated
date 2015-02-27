#!/bin/sh

cat /sys/class/net/eth0/operstate | grep -qi "up" && exit

DO_REBOOT=0

if [ -f /var_init/update/vmlinux.ub.gz ]; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i kernel /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i kernel /proc/mtd | cut -f 0 -s -d :`
	fi
	echo Updating kernel on device $DEV .....
	/usr/sbin/flash_eraseall /dev/$DEV && /bin/cat /var_init/update/vmlinux.ub.gz > /dev/$DEV
	rm /var_init/update/vmlinux.ub.gz
	if [ -f /var/update/vmlinux.ub.gz ]; then
	rm /var/update/vmlinux.ub.gz
	fi
	DO_REBOOT=1
fi

if [ -f /var_init/update/u-boot.bin ]; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i u-boot /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i u-boot /proc/mtd | cut -f 0 -s -d :`
	fi
	echo Updating u-boot on device $DEV .....
	/usr/sbin/flash_eraseall /dev/$DEV && /bin/cat /var_init/update/u-boot.bin > /dev/$DEV
	rm /var_init/update/u-boot.bin
	if [ -f /var/update/u-boot.bin ]; then
	rm /var/update/u-boot.bin
	fi
	DO_REBOOT=1
fi

if [ -f /var_init/update/uldr.bin ]; then
	# check if we are using gnu coreutils
	if [ -e /usr/bin/cut.coreutils ]; then
	# coreutils "cut" counts from 1
	DEV=`grep -i uldr /proc/mtd | cut -f 1 -s -d :`
	else
	# busybox "cut" counts from 0
	DEV=`grep -i uldr /proc/mtd | cut -f 0 -s -d :`
	fi
	echo Updating loader on device $DEV .....
	/usr/sbin/flash_eraseall /dev/$DEV && /bin/cat /var_init/update/uldr.bin > /dev/$DEV
	rm /var_init/update/uldr.bin
	if [ -f /var/update/uldr.bin ]; then
	rm /var/update/uldr.bin
	fi
	DO_REBOOT=1
fi

if [ $DO_REBOOT == 1 ]; then
	echo Reboot...
	sync
	sleep 2
	/sbin/reboot -f
fi
