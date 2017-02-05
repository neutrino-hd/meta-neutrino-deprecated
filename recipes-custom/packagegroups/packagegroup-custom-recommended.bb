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


RDEPENDS_${PN} ?= "\
    autofs \
    dosfstools \
    etckeeper \
    exfat-utils \
    inotify-tools \
    libevent \
    minidlna \
    neutrino-plugin-logo \
    nfs-utils \
    nfs-utils-client \
    ntfs-3g \
    ntfsprogs \
    ntpdate \
    openssh \
    openssl \
    parted \
    rpcbind \
    wpa-supplicant \
"
		
RDEPENDS_${PN}_append_libc_glibc += "kbd-locale-de"

