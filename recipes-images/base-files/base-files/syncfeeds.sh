#!/bin/bash

# install lftp on your host system, copy this file to /usr/bin on your host (chmod755) 
#
# adjust COOLIP (coolstream IP adress), save and call "synchd2.sh"
# after successful sync opkg should be useable on your stb

COOLIP="ipaddress"
USER="root"
PASS="root"
FTPURL="ftp://$USER:$PASS@$COOLIP"
LCD="localdir"
RCD="remotedir"
DELETE="--delete"
lftp -c "set ftp:list-options -a;
open '$FTPURL';
lcd $LCD;
cd $RCD;
mirror --reverse \
       $DELETE \
       --verbose \
       --exclude-glob a-dir-to-exclude/ \
       --exclude-glob a-file-to-exclude \
       --exclude-glob a-file-group-to-exclude* \
       --exclude-glob other-files-to-exclude"

