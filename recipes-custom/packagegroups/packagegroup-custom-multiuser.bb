#
# Copyright (C) 2010 Intel Corporation
#

SUMMARY = "Standard full-featured Linux system multiuser tools"
DESCRIPTION = "Package group bringing in multiuser packages needed for a more traditional full-featured Linux system"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-multiuser \
"

RDEPENDS_packagegroup-custom-multiuser = "\
    cracklib \
    gzip \
    shadow \
    sudo \
    "

