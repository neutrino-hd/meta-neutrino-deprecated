DESCRIPTION = "A library for loose coupling of C++ method calls"
SECTION = "libs"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=d8045f3b8f929c1cb29a1e3fd737b499"

DEPENDS = "mm-common"

SRC_URI = "ftp://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.4/libsigc++-${PV}.tar.xz;name=archive"
SRC_URI[archive.md5sum] = "55945ba6e1652f89999e910f6b52047c"
SRC_URI[archive.sha256sum] = "540443492a68e77e30db8d425f3c0b1299c825bf974d9bfc31ae7efafedc19ec"

S = "${WORKDIR}/libsigc++-${PV}"

inherit autotools

EXTRA_AUTORECONF = "--exclude=autoheader"

FILES_${PN}-dev += "${libdir}/sigc++-*/"
FILES_${PN}-doc += "${datadir}/devhelp"

do_install_append() {
    ln -s ./sigc++-2.0/sigc++ ${D}${includedir}
    cp ${WORKDIR}/build/sigc++config.h ${D}${includedir}
}

BBCLASSEXTEND = "native"

