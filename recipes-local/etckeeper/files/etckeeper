#!/bin/sh
set -e
if [ -x /usr/bin/etckeeper ] && [ -e /etc/etckeeper/etckeeper.conf ]; then
        . /etc/etckeeper/etckeeper.conf
        if [ "$AVOID_DAILY_AUTOCOMMITS" != "1" ]; then
                if [ "$VCS" = hg ]; then
                        hostname=`hostname -f 2>/dev/null || hostname`
                        export HGUSER=cron@$hostname
                fi
                if etckeeper unclean; then
                        etckeeper commit "daily autocommit" >/dev/null
                fi
        fi
fi
