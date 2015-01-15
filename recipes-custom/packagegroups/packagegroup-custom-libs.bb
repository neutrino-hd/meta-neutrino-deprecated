#
# Copyright (C) 2010 Intel Corporation
#

SUMMARY = "Standard full-featured Linux system Libs"
DESCRIPTION = "Package group bringing in Lib packages needed for a more traditional full-featured Linux system"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-libs \
    "

RDEPENDS_packagegroup-custom-libs = "\
    glib-2.0 \
    "
