#
# Copyright (C) 2010 Intel Corporation
#

SUMMARY = "Standard full-featured Linux system services"
DESCRIPTION = "Package group bringing in system-service packages needed for a more traditional full-featured Linux system"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-sys-services \
    "


RDEPENDS_packagegroup-custom-sys-services = "\
    at \
    bzip2 \
    cronie \
    dbus \
    dbus-glib \
    python-dbus \
    gzip \
    less \
    libcap \
    logrotate \
    pciutils \
    libpcre \
    sysfsutils \
    tcp-wrappers \
    wpa-supplicant \
    "

