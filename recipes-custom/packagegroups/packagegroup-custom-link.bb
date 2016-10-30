#
# Copyright (C) 2010 Intel Corporation
#

SUMMARY = "Standard full-featured Linux system services"
DESCRIPTION = "Package group bringing in recommended packages needed for a more traditional full-featured Linux system"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-link \
    "


RDEPENDS_packagegroup-custom-link ?= "\
    autofs \
    dosfstools \
    etckeeper \
    exfat-utils \
    libevent \
    logrotate \
    minidlna \
    nano \
    neutrino-plugin-logo \
    nfs-utils \
    nfs-utils-client \
    ntfs-3g \
    openssh \
    openssl \
    parted \
    rpcbind \
    sysklogd \
"
    

