SUMMARY = "Standard full-featured Linux system Develpement Tools"
DESCRIPTION = "Package group bringing in packages needed for developers"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-dev-utils \
    "

RDEPENDS_packagegroup-custom-dev-utils = "\
    byacc \
    diffutils \
    m4 \
    make \
    patch \
    mtd-utils \
    automake \
    autoconf \
    cmake \
    gcc \
    gdb \
    strace \
    "


