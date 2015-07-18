#
# Copyright (C) 2010 Intel Corporation
#

SUMMARY = "Standard full-featured Linux system services"
DESCRIPTION = "Package group bringing in recommended packages needed for a more traditional full-featured Linux system"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-recommended \
    "


RDEPENDS_packagegroup-custom-recommended ?= "\
    autofs \
    cifs-utils \
    htop \
    libevent \
    logrotate \
    mc \
    mc-fish \
    mc-helpers \
    mc-helpers-perl \
    mc-helpers-python \
    minidlna \
    nano \
    nfs-utils \
    nfs-utils-client \
    openssh \
    rpcbind \
    samba \
    sysklogd \
    tmux \
    util-linux-blkid \
    wpa-supplicant \
"

RDEPENDS_packagegroup-custom-recommended += "${@'' if USE_ETC != 'yes' else 'etckeeper'}"
    

