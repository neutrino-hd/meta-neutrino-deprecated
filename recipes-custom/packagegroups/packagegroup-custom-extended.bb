SUMMARY = "Standard full-featured Linux system extended Tools"
DESCRIPTION = "Package group bringing in extended packages for a more traditional full-featured Linux system"
PR = "r6"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-custom-extended \
    "

RDEPENDS_packagegroup-custom-extended = "\
    iproute2 \
    iputils \
    iptables \
    openssl \
    htop \
    "

