DESCRIPTION = "A library for loose coupling of C++ method calls"
SECTION = "libs"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=d8045f3b8f929c1cb29a1e3fd737b499"

DEPENDS = "mm-common"

SRC_URI = "ftp://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.9/libsigc++-${PV}.tar.xz;name=archive"
SRC_URI[archive.md5sum] = "0e5630fd0557ee80b5e5cbbcebaa2594"
SRC_URI[archive.sha256sum] = "0bf9b301ad6198c550986c51150a646df198e8d1d235270c16486b0dda30097f"

S = "${WORKDIR}/libsigc++-${PV}"

inherit autotools pkgconfig

EXTRA_AUTORECONF = "--exclude=autoheader"

FILES_${PN}-dev += "${libdir}/sigc++-*/"
FILES_${PN}-doc += "${datadir}/devhelp"

do_install_append() {
    ln -s ./sigc++-2.0/sigc++ ${D}${includedir}
    cp ${WORKDIR}/build/sigc++config.h ${D}${includedir}
}

BBCLASSEXTEND = "native"

