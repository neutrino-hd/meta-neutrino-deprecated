SUMMARY = "utilities to create, check, label and dump exFAT filesystem"
DESCRIPTION = "Utilities to manage extended file allocation table filesystem. \
This package provides tools to create, check and label the filesystem. It \
contains \
 - dumpexfat to dump properties of the filesystem \
 - exfatfsck / fsck.exfat to report errors found on a exFAT filesystem \
 - exfatlabel to label a exFAT filesystem \
 - mkexfatfs / mkfs.exfat to create a exFAT filesystem. \
"
HOMEPAGE = "git://github.com/relan/"
SECTION = "universe/otherosfs"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"
SRC_URI = "git://github.com/relan/exfat.git;branch=master"
SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

S = "${WORKDIR}/git"

DEPENDS = "virtual/libc fuse"

inherit autotools-brokensep

SRC_URI[md5sum] = "e592130829d0bf61fa5e3cd1c759d329"
SRC_URI[sha256sum] = "eeacedca1878065dc3886674ae39cd51149c37bd7d6d7e9325c971a1d1acdab3"

CCFLAGS='${CCFLAGS} -std=c99'

do_configure_prepend() {
    autoreconf --install
    ./configure --prefix=/ \
		--host \	
}

do_install_append() {
	rm -r ${D}/share
}
