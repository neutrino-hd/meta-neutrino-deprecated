DESCRIPTION = "A library for loose coupling of C++ method calls"
SECTION = "libs"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=d8045f3b8f929c1cb29a1e3fd737b499"

DEPENDS = "mm-common"

SRC_URI = "ftp://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.4/libsigc++-${PV}.tar.xz;name=archive"
SRC_URI[archive.md5sum] = "c6cd2259f5ef973e4c8178d0abbdbfa7"
SRC_URI[archive.sha256sum] = "7593d5fa9187bbad7c6868dce375ce3079a805f3f1e74236143bceb15a37cd30"


S = "${WORKDIR}/libsigc++-${PV}"

inherit autotools

EXTRA_AUTORECONF = "--exclude=autoheader"

FILES_${PN}-dev += "${libdir}/sigc++-*/"
FILES_${PN}-doc += "${datadir}/devhelp"

BBCLASSEXTEND = "native"

