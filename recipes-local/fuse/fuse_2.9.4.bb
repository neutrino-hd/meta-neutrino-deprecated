SUMMARY = "With FUSE it is possible to implement a fully functional filesystem in a userspace program"
DESCRIPTION = "FUSE (Filesystem in Userspace) is a simple interface for userspace \
programs to export a virtual filesystem to the Linux kernel.  FUSE \
also aims to provide a secure method for non privileged users to \
create and mount their own filesystem implementations. \
"
HOMEPAGE = "http://fuse.sf.net"
SECTION = "libs"
LICENSE = "GPLv2 & LGPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://COPYING.LIB;md5=4fbd65380cdd255951079008b364516c"

SRC_URI = "${SOURCEFORGE_MIRROR}/fuse/fuse-${PV}.tar.gz \
           file://gold-unversioned-symbol.patch \
           file://aarch64.patch \
"
SRC_URI[md5sum] = "ecb712b5ffc6dffd54f4a405c9b372d8"
SRC_URI[sha256sum] = "6be9c0bff6af8c677414935f31699ea5a7f8f5f791cfa5205be02ea186b97ce1"

inherit autotools pkgconfig

DEPENDS = "gettext-native virtual/libiconv"

PACKAGES =+ "fuse-utils-dbg fuse-utils libulockmgr libulockmgr-dev libulockmgr-dbg"

RRECOMMENDS_${PN} = "kernel-module-fuse"

FILES_${PN} += "${libdir}/libfuse.so.*"
FILES_${PN}-dev += "${libdir}/libfuse*.la"

FILES_libulockmgr = "${libdir}/libulockmgr.so.*"
FILES_libulockmgr-dev += "${libdir}/libulock*.la"
FILES_libulockmgr-dbg += "${libdir}/.debug/libulock*"

# Forbid auto-renaming to libfuse-utils
FILES_fuse-utils = "${bindir} ${base_sbindir}"
FILES_fuse-utils-dbg = "${bindir}/.debug ${base_sbindir}/.debug"
DEBIAN_NOAUTONAME_fuse-utils = "1"
DEBIAN_NOAUTONAME_fuse-utils-dbg = "1"

do_install_append() {
    rm -rf ${D}${base_prefix}/dev
}
