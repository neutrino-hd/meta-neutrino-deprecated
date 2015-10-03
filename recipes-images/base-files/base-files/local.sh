#!/bin/sh

# Create symlinks for binaries lying in /etc/neutrino/bin 
cd /etc/neutrino/bin
for i in *; do
        if [ -e /usr/bin/$i ];then
        echo "skipping ... $i already exists"
        else
        ln -s /etc/neutrino/bin/$i /usr/bin
        fi
done
