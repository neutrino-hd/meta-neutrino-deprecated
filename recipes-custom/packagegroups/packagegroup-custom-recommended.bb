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


RDEPENDS_packagegroup-custom-recommended = "\
    cifs-utils \
    djmount \
    libevent \
    nfs-utils \
    nfs-utils-client \
    openssh \
    rpcbind \
    ushare \
    samba \
    util-linux-blkid \
    "

