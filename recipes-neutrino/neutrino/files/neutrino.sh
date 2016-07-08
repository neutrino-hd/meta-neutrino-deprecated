#!/bin/sh

echo "### Starting NEUTRINO ###"
/usr/bin/neutrino > /dev/null 2> /dev/null
/bin/sync

if [ -e /tmp/.reboot ] ; then
    dt -t"Rebooting..."
    systemctl reboot
else
    dt -t"Panic..."
    sleep 5
    systemctl reboot
fi
