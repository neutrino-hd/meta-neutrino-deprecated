#! /bin/sh 

if pdbedit -L | grep root >> /dev/null;then
break
else
(echo root; echo root) | smbpasswd -s -a root
fi

