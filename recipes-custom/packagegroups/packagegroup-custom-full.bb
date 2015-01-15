#
# Copyright (C) 2010 Intel Corporation
#

SUMMARY = "Standard full-featured Linux system"
DESCRIPTION = "Package group bringing in packages needed for a more traditional full-featured Linux system"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-full \
    "

RDEPENDS_packagegroup-custom-full = " \
    packagegroup-custom-libs \
    packagegroup-custom-utils \
    packagegroup-custom-extended \
    packagegroup-custom-dev-utils \
    packagegroup-custom-multiuser \
    packagegroup-custom-sys-services \
"
