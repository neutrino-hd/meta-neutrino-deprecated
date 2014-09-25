DESCRIPTION = "Hierarchical, reference counted memory pool system with destructors"
HOMEPAGE = "http://talloc.samba.org"
LICENSE = "LGPL-3.0+"
LIC_FILES_CHKSUM = "file://talloc.h;beginline=4;endline=25;md5=e437634499a4434b4a24518195ff357d"

inherit autotools pkgconfig

SRC_URI = "http://samba.org/ftp/${BPN}/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "c6e736540145ca58cb3dcb42f91cf57b"
SRC_URI[sha256sum] = "5b810527405f29d54f50efd78bf2c89e318f2cd8bed001f22f2a1412fd27c9b4"

TARGET_CC_ARCH += "${LDFLAGS}"

PR = "r2"

# autoreconf doesn't work well while reconfiguring included libreplace
do_configure () {
       gnu-configize
       oe_runconf
}

do_install_append() {
       install -d ${D}${libdir}
       ln -s libtalloc.so.2.0.1 ${D}${libdir}/libtalloc.so.2.0
       ln -s libtalloc.so.2.0 ${D}${libdir}/libtalloc.so.2
       ln -s libtalloc.so.2 ${D}${libdir}/libtalloc.so
}
