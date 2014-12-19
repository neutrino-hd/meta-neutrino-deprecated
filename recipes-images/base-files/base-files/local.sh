#!/bin/sh

# Start all init scripts in /var/etc
# executing them in numerical order.
#

echo "Starting init scripts from /var/etc/..."
for i in /var/etc/S??* ;do
	# Ignore dangling symlinks (if any).
	[ ! -f "$i" ] && continue
	case "$i" in
	*.sh)
		# Source shell script for speed.
		(
			trap - INT QUIT TSTP
			set start
			. $i
		)
		;;
	*)
		# No sh extension, so fork subprocess.
		$i start
		;;
	esac
done

